
//需要執行這段指令
//npm install express cookie-parser serialport fs

const express = require('express');
const cookieParser = require('cookie-parser');
const { SerialPort } = require('serialport');
const fs = require('fs');
const path = require('path');
const app = express();
const currentDir = process.cwd();
const dirName = path.basename(currentDir);

const comport = process.argv[2] || 'COM4';

app.use(cookieParser()); // 使用 cookie-parser 來解析 cookie

// 定義路由來讀取 cookie
app.get('/read-cookie', (req, res) => {
    const implementCount = req.cookies.implement_count;

    if (implementCount) {
        console.log("從 cookie 中讀取到的 implement_count:", implementCount);
        res.json({ success: true, implementCount: implementCount });
    } else {
        console.log("未找到 implement_count cookie");
        res.json({ success: false, message: '未找到 cookie' });
    }
});

// 寫入文件的函數
async function writeToFile(asciiData) {
    const dirPath = path.join(__dirname, `../${dirName}/api`);
    const filePath = path.join(dirPath, 'final_val.txt');

    console.log("目錄路徑:", dirPath);
    console.log("文件路徑:", filePath);
    console.log("當前工作目錄:", dirName);
  
    await fs.promises.mkdir(dirPath, { recursive: true });

    try {
        await fs.promises.appendFile(filePath, asciiData + '\n');
        console.log("成功寫入文件:", asciiData);
    } catch (err) {
        console.error("寫入文件失敗:", err);
    }
}


// 連接 COM 端口並保持連接
async function connectComPort(port, baudRate, dataBits, stopBits, parity) {
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
        console.log("成功連接到 COM 端口:", port);

        let dataBuffer = Buffer.alloc(0);

        portInstance.on('data', async (data) => {
            dataBuffer = Buffer.concat([dataBuffer, data]);
            console.log("目前的 dataBuffer 長度:", dataBuffer.length);

            while (dataBuffer.length >= 21) {
                const slicedData = dataBuffer.slice(0, 21);
                const hexData = slicedData.toString('hex');
                const Ans = hexData.slice(14, 14 + 10);

                const asciiData = Buffer.from(Ans, 'hex').toString('ascii');
                console.log("數據的十六進制表示:", hexData);
                console.log("轉換為 ASCII:", asciiData);
            
                //取得 是正轉 還是 反轉 
                const result = hexData.substring(12, 14);
                const asciiValue = String.fromCharCode(parseInt(result, 16));
                if (asciiData) {
                    const combinedValue = `${asciiValue} ${asciiData}`.replace(/\s+/g, ' ').trim();
                    console.log("準備寫入的 ASCII 數據:", asciiData);
                    await writeToFile(combinedValue);
                }

                dataBuffer = dataBuffer.slice(21);
            }
        });

        portInstance.on('error', (err) => {
            console.error("串口錯誤:", err.message);
            // 可以在這裡重新連接
        });

    } catch (error) {
        console.error(`無法打開 COM 端口 ${port}: ${error.message}`);
    }
}

// 使用示例，連接 COM 端口
connectComPort(comport, 19200, 8, 2, 'none');

// 啟動伺服器
app.listen(3000, () => {
    console.log('Server is running on port 3000');
});
