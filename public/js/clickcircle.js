let counter = 1;
let selectedCircle = null;
let offsetX, offsetY;
let circleWidth = 30; // 圆形的宽度
let circleHeight = 30; // 圆形的高度

document.getElementById('img-container').addEventListener('mousedown', function(event) {
    let myImg = document.querySelector("#imgId");
    let realWidth = myImg.width;//myImg.naturalWidth //改用div height
    let realHeight = myImg.height;//myImg.naturalHeight //改用div height
    let bias_x = roundTo(30/realWidth*100,2);
    let bias_y = roundTo(30/realHeight*100,2);

    //加入原點偏移
    let move_x = document.getElementById('imgId').getBoundingClientRect().x
    let move_y = document.getElementById('imgId').getBoundingClientRect().y

    if (event.target.classList.contains('circle')) {//已存在
        selectedCircle = event.target;
        offsetX = event.clientX - parseFloat(selectedCircle.style.left);
        offsetY = event.clientY - parseFloat(selectedCircle.style.top);
    } else {//創新的圖形
        let existingCircles = document.querySelectorAll('.circle');
        let foundExisting = false;
        // console.log(existingCircles.length);
        counter = existingCircles.length+1;

        existingCircles.forEach(function(circle) {
            let rect = circle.getBoundingClientRect();
            if (
                event.clientX >= rect.left &&
                event.clientX <= rect.right &&
                event.clientY >= rect.top &&
                event.clientY <= rect.bottom
            ) {
                selectedCircle = circle;
                offsetX = event.clientX - parseFloat(selectedCircle.style.left) - move_x;
                offsetY = event.clientY - parseFloat(selectedCircle.style.top) - move_y;
                foundExisting = true;
            }
        });

        if (!foundExisting) {
            const circle = document.createElement('div');
            circle.classList.add('circle');
            circle.style.width = circleWidth+'px';
            circle.style.height = circleHeight+'px';
            // console.log(circle);
            // circle.innerText = counter;
            // let span = document.createElement('span')
            // span.innerHTML
            // '<span class="inner-text">'+counter+'</span>';
            circle.innerHTML = '<span class="">'+counter+'</span>';
            circle.innerHTML += '<div class="circle-border" onclick="updateParameters('+counter+')"></div>';

            var relativePosition = {
              left: $(document).scrollLeft() + event.clientX - move_x,
              top : $(document).scrollTop() + event.clientY - move_y
            };
            circle.style.top = `${(relativePosition.top / realHeight) * 100 - bias_y}%`;// only image 8
            circle.style.left = `${(relativePosition.left / realWidth) * 100 - bias_x}%`;// only image 4

            circle.style.top = `calc(${(relativePosition.top / realHeight) * 100}% - 15px )`;// only image 8
            circle.style.left = `calc(${(relativePosition.left / realWidth) * 100}% - 15px )`;// only image 8

            circle.setAttribute('data-id', counter);
            document.getElementById('img-container').appendChild(circle);
            counter++;
            new_task();
        }
    }
});

document.addEventListener('mousemove', function(event) {
    let myImg = document.querySelector("#imgId");
    let realWidth = myImg.width;//myImg.naturalWidth
    let realHeight = myImg.height;//myImg.naturalHeight
    let bias_x = roundTo(30/realWidth*100,2)-1;
    let bias_y = roundTo(30/realHeight*100,2)-1;
    let move_x = document.getElementById('imgId').getBoundingClientRect().x
    let move_y = document.getElementById('imgId').getBoundingClientRect().y

    if (selectedCircle) {
        var relativePosition = {
          left: $(document).scrollLeft() + event.clientX - move_x,
          top : $(document).scrollTop() + event.clientY - move_y
        };

        selectedCircle.style.top = `${(relativePosition.top / realHeight) * 100 - bias_y}%`;// only image 8
        selectedCircle.style.left = `${(relativePosition.left / realWidth) * 100 - bias_x}%`;// only image 4

        selectedCircle.style.top = `calc(${(relativePosition.top / realHeight) * 100}% - 15px )`;// only image 8
        selectedCircle.style.left = `calc(${(relativePosition.left / realWidth) * 100}% - 15px )`;// only image 8

        // selectedCircle.style.top = `${(event.clientY / realHeight) * 100 - bias_y}%`;// only image 8
        // selectedCircle.style.left = `${(event.clientX / realWidth) * 100 - bias_x}%`;// only image 4
    }
});

document.addEventListener('mouseup', function() {
    selectedCircle = null;
});

roundTo = function( num, decimal ) { return Math.round( ( num + Number.EPSILON ) * Math.pow( 10, decimal ) ) / Math.pow( 10, decimal ); }

document.getElementById('img-container').addEventListener('dblclick', function(event) {
    edit_task()
    if (event.target.classList.contains('circle')) {
        event.target.remove();
    }
});