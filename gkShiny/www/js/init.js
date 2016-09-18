$(document).ready(function() {
                              $('#circleMarkers').bootstrapSwitch();
                              $('#circleMarkers').bootstrapSwitch('onText', '<span class="glyphicon glyphicon-adjust"></span>');
                              $('#circleMarkers').bootstrapSwitch('onColor', 'primary');
                              $('#circleMarkers').bootstrapSwitch('offText', '<span class="glyphicon glyphicon-map-marker"></span>');
                              $('#circleMarkers').bootstrapSwitch('offColor', 'success');
                                var label='Markeri';
                               $('#circleMarkers').bootstrapSwitch('labelText', label);                             
                                $('#circleMarkers').on('switchChange.bootstrapSwitch', function () {
                              var sw=$('#circleMarkers').bootstrapSwitch('state');
                              Shiny.onInputChange('circleMarkers', sw);
                              sw===false? label='Markeri':label='Krugovi';
                              $('#circleMarkers').bootstrapSwitch('labelText', label);
                              });                              

                              });
