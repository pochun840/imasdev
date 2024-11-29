const WebSocket = require('ws');
const ModbusRTU = require('modbus-serial');
const {SerialPort} = require('serialport');

const comport = process.argv[2] || 'COM11';
let zero = false;
let dataPollingInterval; // 儲存 setInterval 的 ID
let reconnecting = false;


// 創建 WebSocket 伺服器
const wss = new WebSocket.Server({ port: 9527 });
const clients = [];

// 創建 Modbus RTU 客戶端
const modbusClient = new ModbusRTU();
modbusClient.setTimeout(500);

wss.on('connection', function connection(ws) {
  // 将新连接的客户端加入 clients 数组
  clients.push(ws);

  // 接收消息
  ws.on('message', function incoming(message) {
    console.log('received: %s', message);
    if (message == 'enable') {
      // function_enable(1);
    }

    if (message == 'disable') {
      // function_enable(0);
    }

    if (message == 'zero') {
      zero = true;
    }
  });

  // 当连接关闭时，从 clients 数组中移除对应的客户端
  ws.on('close', function() {
    clients.splice(clients.indexOf(ws), 1);
  });

  // 处理连接错误
  ws.on('error', function(err) {
    console.error('WebSocket error:', err);
  });
});

// 廣播訊息給所有連接的客戶端
function broadcast(message) {
  clients.forEach(function(client) {
    if (client.readyState === WebSocket.OPEN) {
      client.send(message);
    }
  });
}

// 連接到 Modbus RTU
async function connectModbus() {
  // 檢查串口是否可用
  SerialPort.list()
    .then(ports => {
      const foundPort = ports.find(port => port.path === comport);
      if (!foundPort) {
        console.error(`端口 ${comport} 不可用，嘗試重新連接...`);
        setTimeout(connectModbus, 5000); // 延遲後重試連接
        return;
      }

      // 嘗試連接 Modbus RTU
      modbusClient.connectRTUBuffered(comport, { baudRate: 9600, parity: "none", dataBits: 8, stopBits: 1 })
        .then(async () => {
          console.log(`成功連接到 ${comport}`);
          await sleep(1000); // 休眠 2 秒
          startDataPolling();
        })
        .catch((e) => {
          console.error('連接失敗:', e);
          setTimeout(connectModbus, 5000); // 重試連接
        });
    })
    .catch(err => {
      console.error('列出端口時發生錯誤:', err);
      setTimeout(connectModbus, 5000); // 重試列出端口
    });
}

// 開始從 Modbus 載入數據
function startDataPolling() {
  // 清除之前的 interval（如果有）
  if (dataPollingInterval) {
    clearInterval(dataPollingInterval);
  }

  dataPollingInterval = setInterval(() => {
    let x, y;
    modbusClient.setID(1);
    modbusClient.readHoldingRegisters(8, 4)
      .then(data => {
        x = data;
        modbusClient.setID(2);
        return modbusClient.readHoldingRegisters(8, 4);
      })
      .then(data => {
        y = data;
        let xx = x.data[2];
        let yy = y.data[2];
        reconnecting = false;
        console.log(`${xx}, ${yy}`);
        broadcast(`${xx}, ${yy}`);

        if (zero) {
          zero = false;
          modbusClient.setID(1);
          modbusClient.writeRegisters(5, [0xff]).then(function() {
            modbusClient.setID(2);
            modbusClient.writeRegisters(5, [0xff]);
          }).catch(function(err) {
            console.error('Error writing zero to register:', err);
          });
        }
      })
      .catch(err => {
        console.error('讀取寄存器時發生錯誤:', err);
      });
  }, 333);
}

// 監控串口變化
function monitorSerialPort() {
  const portList = SerialPort.list();

  portList.then(ports => {
    const foundPort = ports.find(port => port.path === comport);
    
    if (!foundPort && !reconnecting) {
      reconnecting = true;
      console.log(`端口 ${comport} 不可用。嘗試重新連接...`);
      setTimeout(() => {
        connectModbus();
      }, 5000); // 延遲後重試連接
    }
    
    // 每隔一段時間再次檢查
    setTimeout(monitorSerialPort, 5000);
  }).catch(err => {
    console.error('列出端口時發生錯誤:', err);
  });
}

function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}


// 開始監控和連接
connectModbus();
monitorSerialPort();

modbusClient.on('error', function(err) {
  console.error('Modbus 客戶端錯誤:', err);
});