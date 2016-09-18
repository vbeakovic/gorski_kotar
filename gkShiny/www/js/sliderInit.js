$('link[rel=stylesheet][href*="ion.rangeSlider.skinShiny.css"]').remove();
//$("#priceEURM2").ionRangeSlider();
$(document).ready(function() {
        $("#priceEURM2").ionRangeSlider({
            type: "double",
            min: 0,
            max: 50,
            from: 10,
            from_min: 10,
            from_max: 50,
            //from_shadow: true,
            to: 50,
            to_min: 10,
            to_max: 50,
            //to_shadow: true,
            grid: true,
            grid_num: 10,
            postfix: " EUR/m2",
            decorate_both: false
        });
        $("#area").ionRangeSlider({
            type: "double",
            min: 0,
            max: 10000,
            from: 500,
            from_min: 300,
            from_max: 10000,
            //from_shadow: true,
            to: 10000,
            to_min: 300,
            to_max: 10000,
            //to_shadow: true,
            grid: true,
            grid_num: 10,
            postfix: " m2",
            decorate_both: false
        });
        $("#hrBond").ionRangeSlider({
            type: "single",
            min: 0,
            max: 10,
            from: 5,
            from_min: 0.5,
            from_max: 10,
            from_shadow: true,
            //to: 10000,
            //to_min: 300,
            //to_max: 10000,
            //to_shadow: true,
            grid: true,
            grid_num: 10,
            postfix: " %",
            //decorate_both: false
        });
        $("#liq").ionRangeSlider({
            type: "single",
            min: 0,
            max: 10,
            from: 2,
            from_min: 0.5,
            from_max: 5,
            from_shadow: true,
            //to: 10000,
            //to_min: 300,
            //to_max: 10000,
            //to_shadow: true,
            grid: true,
            grid_num: 10,
            postfix: " %",
            //decorate_both: false
        });
        $("#fin").ionRangeSlider({
            type: "single",
            min: 0,
            max: 10,
            from: 5,
            from_min: 0.5,
            from_max: 10,
            from_shadow: true,
            //to: 10000,
            //to_min: 300,
            //to_max: 10000,
            //to_shadow: true,
            grid: true,
            grid_num: 10,
            postfix: " %",
            //decorate_both: false
        });
        $("#addition").ionRangeSlider({
            type: "single",
            min: 0,
            max: 10,
            from: 5,
            from_min: 0.5,
            from_max: 10,
            from_shadow: true,
            //to: 10000,
            //to_min: 300,
            //to_max: 10000,
            //to_shadow: true,
            grid: true,
            grid_num: 10,
            postfix: " %",
            //decorate_both: false
        });
        $("#priceSlider").ionRangeSlider({
            type: "single",
            min: 0,
            max: 100,
            from: 10,
            from_min: 5,
            from_max: 100,
            from_shadow: true,
            //to: 10000,
            //to_min: 300,
            //to_max: 10000,
            //to_shadow: true,
            grid: true,
            grid_num: 10,
            postfix: " EUR/m2",
            //decorate_both: false
        });
        $("#realReturnSlider").ionRangeSlider({
            type: "single",
            min: 0,
            max: 20,
            from: 5,
            from_min: 0,
            from_max: 20,
            from_shadow: true,
            //to: 10000,
            //to_min: 300,
            //to_max: 10000,
            //to_shadow: true,
            grid: true,
            grid_num: 10,
            postfix: " %",
            //decorate_both: false
        });
});