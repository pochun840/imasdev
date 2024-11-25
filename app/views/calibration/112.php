let final_brian = 0;
async function fetchData() {
    const url1 = '?url=Calibrations/get_val';
    try {
        const response1 = await fetch(url1, {
            method: 'GET', 
        });

        if (response1.ok) {
            const textResponse = await response1.text(); // 先获取响应的文本内容
            
            if (textResponse.trim()) {
                try {
                    const data = JSON.parse(textResponse);
                    console.log('API 返回:', data);

                     if (data.success === true && data.message === '數據整理成功') {
                        final_brian += 1; 
                    }

                } catch (jsonError) {
                    //console.error('无法解析响应为 JSON:', jsonError);
                }
            }
        }else{
            console.error('请求失败，状态码:', response1.status);
        }
    } catch (error) {
        console.error('发生错误:', error);
    }
}

// 每 0.5 秒调用一次 fetchData
setInterval(fetchData, 500);
fetchData();

修改  
如果  final_brian 與 localstorage的 implement_count 一致
就要alert 訊息 且  fetchData 就不能繼續 每0.5秒 執行一次


------------------------------------------------------------------


let final_brian = 0; // 初始化计数器
let intervalId; // 用于保存 setInterval 的 ID，方便停止定时器

async function fetchData() {
    // 获取 localStorage 中的 implement_count
    const implementCount = parseInt(localStorage.getItem('implement_count')) || 0;

    // 如果 final_brian 和 implement_count 一致，停止 fetchData 执行并弹出警告
    if (final_brian === implementCount) {
        alert('请求次数已达到限制，停止继续请求！');
        clearInterval(intervalId); // 停止 setInterval
        return; // 退出函数，停止执行 fetchData
    }

    const url1 = '?url=Calibrations/get_val';
    try {
        const response1 = await fetch(url1, {
            method: 'GET',
        });

        if (response1.ok) {
            const textResponse = await response1.text(); // 获取响应的文本内容

            if (textResponse.trim()) {
                try {
                    const data = JSON.parse(textResponse);
                    console.log('API 返回:', data);

                    // 如果返回的数据是 '數據整理成功'，增加 final_brian
                    if (data.success === true && data.message === '數據整理成功') {
                        final_brian += 1;
                        console.log('final_brian 增加到:', final_brian);
                    }

                } catch (jsonError) {
                    console.error('无法解析响应为 JSON:', jsonError);
                }
            }
        } else {
            console.error('请求失败，状态码:', response1.status);
        }
    } catch (error) {
        console.error('发生错误:', error);
    }
}

// 每 0.5 秒调用一次 fetchData
intervalId = setInterval(fetchData, 500);
fetchData(); // 初次调用 fetchData
