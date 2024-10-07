
var GridConfig = {
    generate: function(width, height, left, top) {
        return {
            width: width || '90%',  
            height: height || '70%', 
            left: left || '3%',  
            top: top || '20%' 
        };
    }
};
 
function generateTooltipContent(params) {
    var tooltipContent = '';
    for (var i = 0; i < params.length; i++) {
        var seriesName = params[i].seriesName;
        var dataValue = params[i].value;
        var color = params[i].color;
        tooltipContent += '<span style="color:' + color + ';">' + seriesName + ': ' + dataValue + '</span><br>';
    }
    return tooltipContent;
}


function generateDataZoom() {
    return [
        {
            type: 'inside',
            start: 0,
            end: 100
        },
        {
            show: false,
            type: 'slider',
            start: 0,
            end: 100,
            handleIcon: 'M10.7,11.9v-1.3H9.3v1.3c-4.9,0.3-8.8,4.4-8.8,9.4c0,5,3.9,9.1,8.8,9.4v1.3h1.3v-1.3c4.9-0.3,8.8-4.4,8.8-9.4C19.5,16.3,15.6,12.2,10.7,11.9z M13.3,24.4H6.7V23h6.6V24.4z M13.3,19.6H6.7v-1.4h6.6V19.6z',
            handleSize: '80%',
            handleStyle: {
                color: '#fff',
                shadowBlur: 3,
                shadowColor: 'rgba(0, 0, 0, 0)',
                shadowOffsetX: 0,
                shadowOffsetY: 0
            }
        }
    ];
}

function generateChartInfo(data, chartIndex) {
    var prefix = 'chart' + chartIndex + '_';
    return {
        x_data_val: data[prefix + 'xcoordinate'],
        y_data_val: data[prefix + 'ycoordinate'],
        y_data_val_angle: data[prefix + 'ycoordinate_angle'] || null,
        min_val: data[prefix + 'ycoordinate_min'],
        max_val: data[prefix + 'ycoordinate_max'],
        min_val_angle: data[prefix + 'ycoordinate_min_angle'] || null,
        max_val_angle: data[prefix + 'ycoordinate_max_angle'] || null,
        xtitle: data['chart_combine']['x_title'],
        ytitle: data['chart_combine']['y_title'],
        job: data['info_final'][chartIndex - 1]['job_name']
    };
}








