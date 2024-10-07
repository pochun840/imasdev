const { SerialPort } = require('serialport');
const fs = require('fs'); // 引入文件系统模块
const path = require('path'); // 引入路径模块

async function writeToFile(asciiData) {
    const dirPath = path.join(__dirname, '../imasdev/api'); // 构建目录路径
    const filePath = path.join(dirPath, 'final_val.txt'); // 构建文件路径

    console.log("目錄路徑:", dirPath);
    console.log("文件路徑:", filePath);

    // 检查目录是否存在，如果不存在则创建
    await fs.promises.mkdir(dirPath, { recursive: true });

    // 追加写入文件
    await fs.promises.appendFile(filePath, asciiData + '\n');
    console.log("成功寫入文件:", asciiData);
}

async function sendToApi(asciiData) {
    const url = 'http://192.168.0.161/imasdev/public/index.php?url=Calibrations/get_val';

    const { default: fetch } = await import('node-fetch');

    try {
        const response = await fetch(url, {
            method: 'POST',
            body: asciiData, 
            timeout: 5000 // 设置超时为 5 秒
           
        });

        // 如果 ASCII 数据存在，可以直接处理
        if (asciiData) {
            console.log("發送的value:", asciiData);
        }

        const textResponse = await response.text(); // 获取原始响应文本

        if (response.ok) {
            try {
                const jsonResponse = JSON.parse(textResponse); // 尝试解析 JSON
                if (jsonResponse.success) {
                    console.log("API 執行成功:", jsonResponse.message);
                    return "API 執行成功"; 
                } else {
                    console.error("API 執行失敗:", jsonResponse.message);
                    return "API 執行失敗"; 
                }
            } catch (e) {
                console.error("响应不是有效的 JSON:", textResponse);
                return "响应错误"; 
            }
        } else {
            console.error(`連接失敗，狀態碼: ${response.status}`);
            return "連接失敗"; 
        }
    } catch (error) {
        console.error("發送到 API 失敗:", error);
        return "發送失敗"; 
    }
}


async function connectComPort(port, baudRate, dataBits, stopBits, parity, forceClose = false) {
    const response = {};
    const portInstance = new SerialPort({
        path: port,
        baudRate: baudRate,
        dataBits: dataBits,
        stopBits: stopBits,
        parity: parity,
        autoOpen: false,
    });

    try {
        await portInstance.open();
        response.success = true;
        response.message = "成功連接";

        let dataBuffer = Buffer.alloc(0); // 初始化一个空的 Buffer

        portInstance.on('data', async (data) => {
            dataBuffer = Buffer.concat([dataBuffer, data]); // 将新数据附加到 dataBuffer

            while (dataBuffer.length >= 21) {
                const slicedData = dataBuffer.slice(0, 21); // 取前 21 字节
                const hexData = slicedData.toString('hex'); // 转换为十六进制
                const Ans = hexData.slice(14, 14 + 10);

                const asciiData = Buffer.from(Ans, 'hex').toString('ascii');
                console.log("數據的十六進制表示:", hexData);
                console.log("轉換為 ASCII:", asciiData);

                if (asciiData) {
                    await writeToFile(asciiData); // 写入文件
                    //const apiResponse = await sendToApi(asciiData); // 发送到 API
                    //console.log("API 返回:", apiResponse);
                }

                dataBuffer = dataBuffer.slice(21); // 更新 dataBuffer，保留剩余数据
            }
        });

        portInstance.on('error', (err) => {
            console.error("串口錯誤:", err.message);
        });

    } catch (error) {
        response.success = false;
        response.message = `無法打開 COM 端口 ${port}: ${error.message}`;
        console.error(error);
    }

    return response;
}

// 使用示例
connectComPort('COM4', 19200, 8, 2, 'none', false).then(console.log);
