const WebSocket = require('ws');
const sqlite3 = require('sqlite3').verbose();
const os = require('os'); // 引入 os 模組以獲取本機 IP


// 連接到 SQLite 資料庫
const db = new sqlite3.Database('./cc.db', (err) => {
    if (err) {
        console.error('Error opening database ' + err.message);
    } else {
        console.log('Connected to the SQLite database.');
    }
});

let url = ''; // default 替換為您的 WebSocket server URL
let ip = '192.168.0.115';
let localIpAddress = ''; // 儲存本機 IP 地址

// 獲取本機 IP 地址的函數
const getLocalIpAddress = () => {
    const interfaces = os.networkInterfaces();
    for (const interfaceName in interfaces) {
        for (const interfaceInfo of interfaces[interfaceName]) {
            // 濾除內部地址和 IPv6 地址
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
            console.log(row[0].value);
            ip = row[0].value;
            url = 'ws://' + ip + ':3000';
            resolve(url);
        });
    });
};

// 使用撈取到的 URL 建立 WebSocket 連接
fetchWebSocketUrl().then(url => {
    const ws = new WebSocket(url);
    console.log(`Connecting to: ${url}`);

    // 每秒撈取一次最新資料並發送給 server
    setInterval(async () => {
        try {
            const rows = await fetchLatestData();
            // 將資料轉換成 JSON 格式並發送給 server
            if (rows.length > 0) {
                // ws.send(JSON.stringify(rows)); // 確保這裡發送的是字符串
                const messageToSend = {
                    clientIp: localIpAddress, // 使用已獲取的本機 IP 地址
                    data: rows // 將撈取到的資料加入
                };
                ws.send(JSON.stringify(messageToSend)); // 發送包含 IP 和資料
            }
        } catch (error) {
            console.error('Error fetching data:', error.message);
        }
    }, 1000); // 每1000毫秒（1秒）執行一次

    ws.on('open', () => {
        console.log('Connected to server');
    });

    ws.on('message', (data) => {
        // 確保接收到的數據是文字
        console.log(`Received from server: ${data}`);
    });

    ws.on('close', () => {
        console.log('Disconnected from server');
    });

}).catch(error => {
    console.error('Error fetching WebSocket URL:', error.message);
});

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
