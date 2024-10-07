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
    if(message == 'enable'){
      // function_enable(1);
    }

    if(message == 'disable'){
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
});

function broadcast(message) {
  clients.forEach(function(client) {
    if (client.readyState === WebSocket.OPEN) {
      client.send(message);
    }
  });
}


modbusClient.connectRTUBuffered(comport, { baudRate: 9600, parity: "none", dataBits: 8, stopBits: 1 })
   .then(function() {
        	setInterval(function () {
          	var x,y;
            modbusClient.setID(1);
            modbusClient.readHoldingRegisters(8, 4).then(function(data, err) {
      			    // console.log(data);
      			    x = data;
      			    // console.log(x);

      			    modbusClient.setID(2);
                  	modbusClient.readHoldingRegisters(8, 4).then(function(data, err) {
                  		y = data;
            					let xx = x.data[2]
            					let yy = y.data[2]
            					broadcast(xx+','+yy);
                      if(zero){
                        zero = false;
                        // console.log('zero')
                        modbusClient.setID(1);
                        modbusClient.writeRegisters(5, [0xff]).then(function(data, err) {
                          modbusClient.setID(2);
                          modbusClient.writeRegisters(5, [0xff]).then(function(data, err) {
                          });  
                        });
                      }

                  	});
      			});

            }, 333);

    })
    .catch(function(e) {
        // mbsState  = MBS_STATE_FAIL_CONNECT;
        mbsStatus = e.message;
        console.log(e);
    });



// function function_enable(argument) {
//   let net = require('net');
//   let Modbus = require('jsmodbus');

//   let socket = new net.Socket();
//   let client = new Modbus.client.TCP(socket);

//   let options = {
//     'host': '192.168.0.42', // Modbus TCP 设备的 IP 地址
//     'port': 502, // Modbus TCP 端口（默认为502）
//   };

//   socket.connect(options);


//   socket.on('connect', function () {
//     client.writeSingleRegister(461, argument)
//       .then(function (resp) {
//         console.log(resp)
//         socket.end()
//       }).catch(function () {
//         console.error(arguments)
//         socket.end()
//       })
//   })


//   socket.on('error', function(err) {
//     console.error(err);
//     socket.end(); // 关闭连接
//   });

// }

let canCall = true;


function function_enable(argument) {
  if (canCall) {
    canCall = false;

    let net = require('net');
    let Modbus = require('jsmodbus');

    let socket = new net.Socket();
    let client = new Modbus.client.TCP(socket,1,5000);
    // client.setTimeout(5000);

    let options = {
      'host': '192.168.0.42', // Modbus TCP 设备的 IP 地址
      'port': 502, // Modbus TCP 端口（默认为502）
    };

    socket.connect(options);

    socket.on('connect', function () {
      // client.setTimeout(1000); 
      client.writeSingleRegister(461, argument)
        .then(function (resp) {
          console.log(resp)
          socket.end()
          canCall = true;
        }).catch(function () {
          console.error(arguments)
          socket.end()
        })
    })

    socket.on('error', function(err) {
      console.error(err);
      socket.end(); // 关闭连接
    });

    // setTimeout(() => {
    //   canCall = true;
    // }, 400); // Set the interval (in milliseconds) between consecutive calls
  }
}
