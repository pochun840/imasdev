const WebSocket = require('ws');
const sqlite3 = require('sqlite3').verbose();
const os = require('os');
const fs = require('fs');

fs.writeFileSync(`..\\node_pid_client.txt`, process.pid.toString());

// 連接到 SQLite 資料庫
const db = new sqlite3.Database('..\\cc.db', (err) => {
    if (err) {
        console.error('Error opening database ' + err.message);
    } else {
        console.log('Connected to the SQLite database.');
    }
});

let ip = 'localhost';
let url = ''; // default 替換為您的 WebSocket server URL
let localIpAddress = ''; // 儲存本機 IP 地址
let reconnectInterval = 5000;  // 重新連接間隔時間 (毫秒)
let ws; // 將 WebSocket 定義在外部作用域，便於重連時重用

// 獲取本機 IP 地址的函數
const getLocalIpAddress = () => {
    const interfaces = os.networkInterfaces();
    for (const interfaceName in interfaces) {
        for (const interfaceInfo of interfaces[interfaceName]) {
            if (interfaceInfo.family === 'IPv4' && !interfaceInfo.internal) {
                return interfaceInfo.address;
            }
        }
    }
    return '127.0.0.1'; // 如果無法找到，返回回環地址
};

// 一開始獲取本機 IP 地址
localIpAddress = getLocalIpAddress();
console.log(`Local IP Address: ${localIpAddress}`);

// 撈取 WebSocket URL 的函數
const fetchWebSocketUrl = () => {
    return new Promise((resolve, reject) => {
        db.all("SELECT * FROM system_config WHERE config_name = 'monitor_server_ip'", [], (err, row) => {
            if (err) {
                return reject(err);
            }
            ip = row[0].value;
            url = 'ws://' + ip + ':3000';
            resolve(url);
        });
    });
};

// 建立 WebSocket 連接的函數，帶有自動重連邏輯
const connectWebSocket = () => {
    fetchWebSocketUrl().then(url => {
        console.log(`Connecting to: ${url}`);
        ws = new WebSocket(url);

        ws.on('open', () => {
            console.log('Connected to server');

            // 每秒撈取一次最新資料並發送給 server
            setInterval(async () => {
                try {
                    const rows = await fetchLatestData();
                    if (rows.length > 0) {
                        const messageToSend = {
                            clientIp: localIpAddress, // 使用本機 IP 地址
                            data: rows // 將撈取到的資料加入
                        };
                        ws.send(JSON.stringify(messageToSend));
                    }
                } catch (error) {
                    console.error('Error fetching data:', error.message);
                }
            }, 1000); // 每1000毫秒（1秒）執行一次
        });

        ws.on('message', (data) => {
            console.log(`Received from server: ${data}`);
        });

        ws.on('close', () => {
            console.log('Disconnected from server');
            console.log('連線已關閉，正在重新連線...');
            setTimeout(connectWebSocket, reconnectInterval);  // 延遲後重新連線
        });

        ws.on('error', (err) => {
            console.error('WebSocket 發生錯誤:', err.message);
            ws.close();  // 關閉連線以觸發重連
        });

    }).catch(error => {
        console.error('Error fetching WebSocket URL:', error.message);
        setTimeout(connectWebSocket, reconnectInterval);  // 若撈取 URL 失敗，也設定延遲重試
    });
};

// 初始化 WebSocket 連接
connectWebSocket();

// 撈取最新資料的函數
const fetchLatestData = () => {
    return new Promise((resolve, reject) => {
        db.all("SELECT * FROM fasten_data ORDER BY id DESC LIMIT 1", [], (err, rows) => {
            if (err) {
                return reject(err);
            }
            resolve(rows);
        });
    });
};

// 關閉資料庫連接
process.on('exit', () => {
    db.close((err) => {
        if (err) {
            console.error(err.message);
        }
        console.log('Closed the database connection.');
    });
});
