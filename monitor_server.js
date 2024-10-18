const WebSocket = require('ws');
const fs = require('fs');
fs.writeFileSync(`..\\node_pid_server.txt`, process.pid.toString());


const wss = new WebSocket.Server({ port: 3000 });

wss.on('connection', (ws) => {
    console.log('Client connected');

    // 當收到訊息時，將其廣播給所有已連線的 client
    ws.on('message', (message) => {
        console.log(`Received message: ${message}`);

        // 廣播訊息給所有已連線的 client
        wss.clients.forEach((client) => {
            if (client.readyState === WebSocket.OPEN) {
                client.send(message.toString());
            }
        });
    });

    ws.on('close', () => {
        console.log('Client disconnected');
    });

    ws.on('error', (error) => {
        console.error(`WebSocket error: ${error}`);
    });
});

console.log('WebSocket server is running on ws://localhost:3000');

//******************* */

// const WebSocket = require('ws');
// // const ModbusRTU = require('modbus-serial');

// const comport = process.argv[2] || 'COM4';

// let zero = false;

// // 创建 WebSocket 服务器
// const wss = new WebSocket.Server({ port: 3000 });

// // 存储所有连接的客户端
// const clients = [];

// wss.on('connection', function connection(ws) {
//   // 将新连接的客户端加入 clients 数组
//   clients.push(ws);

//   // 接收消息
//   ws.on('message', function incoming(message) {
//     console.log('received: %s', message);
//     broadcast(message)
//   });

//   // 当连接关闭时，从 clients 数组中移除对应的客户端
//   ws.on('close', function() {
//     clients.splice(clients.indexOf(ws), 1);
//   });

//   // 处理连接错误
//   ws.on('error', function(err) {
//     console.error('WebSocket error:', err);
//   });
// });

// function broadcast(message) {
//   clients.forEach(function(client) {
//     if (client.readyState === WebSocket.OPEN) {
//       client.send(message.toString());
//     }
//   });
// }

// console.log('WebSocket server is running on ws://localhost:3000');