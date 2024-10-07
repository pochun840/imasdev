const WebSocket = require('ws');
const ModbusRTU = require('modbus-serial');

const comport = process.argv[2] || 'COM4';

let zero = false;

// 创建 WebSocket 服务器
const wss = new WebSocket.Server({ port: 9527 });

// 存储所有连接的客户端
const clients = [];

// 创建 Modbus RTU 客户端
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

function broadcast(message) {
  clients.forEach(function(client) {
    if (client.readyState === WebSocket.OPEN) {
      client.send(message);
    }
  });
}

function connectModbus() {
  modbusClient.connectRTUBuffered(comport, { baudRate: 9600, parity: "none", dataBits: 8, stopBits: 1 })
    .then(function() {
      console.log(`Connected to ${comport}`);
      setInterval(function() {
        var x, y;
        modbusClient.setID(1);
        modbusClient.readHoldingRegisters(8, 4).then(function(data) {
          x = data;
          modbusClient.setID(2);
          modbusClient.readHoldingRegisters(8, 4).then(function(data) {
            y = data;
            let xx = x.data[2];
            let yy = y.data[2];
            broadcast(xx + ',' + yy);
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
          }).catch(function(err) {
            console.error('Error reading register from ID 2:', err);
          });
        }).catch(function(err) {
          console.error('Error reading register from ID 1:', err);
        });
      }, 333);
    })
    .catch(function(e) {
      console.error('Failed to connect:', e);
      setTimeout(connectModbus, 5000); // 重试连接
    });
}

connectModbus();

modbusClient.on('error', function(err) {
  console.error('Modbus client error:', err);
  setTimeout(connectModbus, 5000); // 在错误发生后尝试重新连接
});
