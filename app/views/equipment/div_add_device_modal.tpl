<!-- modal Add Equipment SubMenu -->

    <!-- Add GTCS --> 
    <div class="modal" id="myModal">
        <div class="modal-dialog">
            <div class="modal-content w3-animate-zoom">
                <header class="modal-header">
                    <h4 id="modal_head" >Add GTCS</h4>
                    <span class="close w3-display-topright">&times;</span>
                </header>
                <div class="modal-body">
                    <div class="row t4">
                        <div class="col-2 t3">Name:</div>
                        <div class="col-4 t4">
                            <input type="text" class="t5 form-control input-ms" id="GTCS-name" maxlength="" required>
                        </div>
                        <div class="col-2 t3">Module:</div>
                        <div class="col-3 t4">
                            <input type="text" class="t5 form-control input-ms" id="GTCS-module" value="GTCS" maxlength="" required>
                        </div>
                    </div>

                    <hr style="color: #000;border: 0.5px solid #000;">

                    <div>
                        <label style="font-size: 18px">
                            <img style="height: 25px; width: 25px" class="images" src="./img/connection-control.svg" alt="">&nbsp;
                            <b>Connection control</b>
                        </label>
                    </div>
                    <div class="row t3">
                        <div class="col-6 t4 form-check form-check-inline">
                            <input class="form-check-input" type="radio" name="Modbus" id="GTCS-modbus-RS232" value="1" style="zoom:1.0; vertical-align: middle">&nbsp;
                            <label class="form-check-label" for="modbus-RS232">Modbus RTU/RS232</label>
                        </div>
                    </div>

                    <div class="row t3">
                        <div class="col t4" style=" margin-right: 3px">
                            <select id="unit" style="width: 70px" class="t4">
                                <option value="1">com 3</option>
                                <option value="2">com 5</option>
                            </select>
                        </div>
                        <div class="col t4">
                            <select id="unit" style="width: 80px" class="t4">
                                <option value="1">115200</option>
                                <option value="2">57600</option>
                                <option value="3">38400</option>
                                <option value="4">9600</option>
                                <option value="5">4800</option>
                                <option value="6">2400</option>
                                <option value="7">1200</option>
                            </select>
                        </div>
                        <div class="col t4">
                            <select id="unit" style="width: 70px" class="t4">
                                <option value="1">None</option>
                                <option value="2">Odd</option>
                                <option value="2">Even</option>
                                <option value="2">Mark</option>
                                <option value="2">Space</option>
                            </select>
                        </div>
                        <div class="col t4">
                            <select id="unit" style="width: 50px" class="t4">
                                <option value="1">8</option>
                                <option value="2">7</option>
                                <option value="3">6</option>
                                <option value="4">5</option>
                                <option value="5">4</option>
                                <option value="6">3</option>
                                <option value="7">2</option>
                                <option value="8">1</option>
                            </select>
                        </div>
                        <div class="col t4">
                            <select id="unit" style="width: 50px" class="t4">
                                <option value="1">10</option>
                                <option value="2">4</option>                         
                                <option value="3">1</option>
                                <option value="4">3</option>
                            </select>
                        </div>
                    </div>

                    <div class="row t3">
                        <div class="col-6 t4 form-check form-check-inline">
                            <input class="form-check-input" type="radio" name="connection-control" id="Modbus-TCP-IP" value="1" onclick="EquipmentCheckbox('gtcs')" style="zoom:1.0; vertical-align: middle">&nbsp;
                            <label class="form-check-label" for="Modbus-TCP-IP">Modbus TCP/IP</label>
                        </div>
                    </div>

                    <div class="row t4">
                        <div class="col-3 t3">Network IP:</div>
                        <div class="col-4 t4">
                            <input type="text" class="t5 form-control input-ms" id="Network-IP" value="192.168.0.184" maxlength="" required>
                        </div>
                        <div class="col-2 t3">Port:</div>
                        <div class="col-2 t4">
                            <input type="text" class="t5 form-control input-ms" id="Communication-Port" value="502" maxlength="" required>
                        </div>
                    </div>

                    <hr style="color: #000;border: 0.5px solid #000;">

                    <div>
                        <label style="font-size: 18px">
                            <img style="height: 25px; width: 25px" class="images" src="./img/test-adjust.png" alt="">&nbsp;
                            <b>Test adjust</b>
                        </label>
                    </div>
                    <div class="row t4">
                        <div class="col-3 t3">Status:
                            <label style="color: red; padding-left: 5%"> offline/online</label>
                        </div>
                        <div class="col">
                            <button type="button" class="btn btn-Reconnect" style="float: right">Reconnect</button>
                        </div>
                    </div>
                    <div class="row t4">
                        <div class="col t3"><b>Communication log</b></div>
                    </div>

                    <div class="scrollbar-AddEquipmentlog" id="style-AddEquipmentlog">
                        <div class="force-overflow-AddEquipmentlog">
                            <div class="row t4">
                                <div class="col t3">2024/02/26 14:00 P.M equipment connect successfully</div>
                            </div>
                            <div class="row t4">
                                <div class="col t3">2024/02/26 2:15 P.M equipment connect failed</div>
                            </div>
                        </div>
                    </div>

                    <div class="w3-center">
                        <button id="Add-GTCS" class="btn-Addsave" onclick="new_task_save()">Save</button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Add ARM -->
    <div class="modal" id="myModal">
        <div class="modal-dialog">
            <div class="modal-content w3-animate-zoom">
                <header class="modal-header">
                    <h4 id="modal_head" >Add ARM</h4>
                    <span class="close w3-display-topright">&times;</span>
                </header>
                <div class="modal-body">
                    <div class="row t4">
                        <div class="col-2 t3">Name:</div>
                        <div class="col-4 t4">
                            <input type="text" class="t5 form-control input-ms" id="ARM-name" maxlength="" required>
                        </div>
                        <div class="col-2 t3">Module:</div>
                        <div class="col-3 t4">
                            <input type="text" class="t5 form-control input-ms" id="ARM-module" value="GTCS" maxlength="" required>
                        </div>
                    </div>

                    <hr style="color: #000;border: 0.5px solid #000;">

                    <div>
                        <label style="font-size: 18px">
                            <img style="height: 25px; width: 25px" class="images" src="./img/connection-control.svg" alt="">&nbsp;
                            <b>Connection control</b>
                        </label>
                    </div>
                    <div class="row t3">
                        <div class="col-6 t4 form-check form-check-inline">
                            <input class="form-check-input" type="radio" name="Modbus" id="ARM-modbus-RS232" value="1" style="zoom:1.0; vertical-align: middle">&nbsp;
                            <label class="form-check-label" for="modbus-RS232">Modbus RTU/RS232</label>
                        </div>
                    </div>

                    <div class="row t3">
                        <div class="col t4" style=" margin-right: 3px">
                            <select id="unit" style="width: 70px" class="t4">
                                <option value="1">com 3</option>
                                <option value="2">com 5</option>
                            </select>
                        </div>
                        <div class="col t4">
                            <select id="unit" style="width: 80px" class="t4">
                                <option value="1">115200</option>
                                <option value="2">57600</option>
                                <option value="3">38400</option>
                                <option value="4">9600</option>
                                <option value="5">4800</option>
                                <option value="6">2400</option>
                                <option value="7">1200</option>
                            </select>
                        </div>
                        <div class="col t4">
                            <select id="unit" style="width: 70px" class="t4">
                                <option value="1">None</option>
                                <option value="2">Odd</option>
                                <option value="2">Even</option>
                                <option value="2">Mark</option>
                                <option value="2">Space</option>
                            </select>
                        </div>
                        <div class="col t4">
                            <select id="unit" style="width: 50px" class="t4">
                                <option value="1">8</option>
                                <option value="2">7</option>
                                <option value="3">6</option>
                                <option value="4">5</option>
                                <option value="5">4</option>
                                <option value="6">3</option>
                                <option value="7">2</option>
                                <option value="8">1</option>
                            </select>
                        </div>
                        <div class="col t4">
                            <select id="unit" style="width: 50px" class="t4">
                                <option value="1">10</option>
                                <option value="2">4</option>
                                <option value="3">1</option>
                                <option value="4">3</option>
                            </select>
                        </div>
                    </div>

                    <div class="row t3">
                        <div class="col-6 t4 form-check form-check-inline">
                            <input class="form-check-input" type="radio" name="connection-control" id="Modbus-TCP-IP" value="1" onclick="EquipmentCheckbox('gtcs')" style="zoom:1.0; vertical-align: middle">&nbsp;
                            <label class="form-check-label" for="Modbus-TCP-IP">Modbus TCP/IP</label>
                        </div>
                    </div>

                    <div class="row t4">
                        <div class="col-3 t3">Network IP:</div>
                        <div class="col-4 t4">
                            <input type="text" class="t5 form-control input-ms" id="Network-IP" value="192.168.0.184" maxlength="" required>
                        </div>
                        <div class="col-2 t3">Port:</div>
                        <div class="col-2 t4">
                            <input type="text" class="t5 form-control input-ms" id="Communication-Port" value="502" maxlength="" required>
                        </div>
                    </div>
                    <div>
                        <label style="font-size: 18px">
                            <b>Zero point calibration</b>&nbsp;&nbsp;
                            <button type="button" class="btn-ZeroReset">Zero Reset</button>
                        </label>
                        <div>

                        </div>
                    </div>

                    <hr style="color: #000;border: 0.5px solid #000;">

                    <div>
                        <label style="font-size: 18px">
                            <img style="height: 25px; width: 25px" class="images" src="./img/test-adjust.png" alt="">&nbsp;
                            <b>Test adjust</b>
                        </label>
                    </div>
                    <div class="row t4">
                        <div class="col-3 t3">Status:
                            <label style="color: red; padding-left: 5%"> offline/online</label>
                        </div>
                        <div class="col">
                            <button type="button" class="btn btn-Reconnect" style="float: right">Reconnect</button>
                        </div>
                    </div>
                    <div class="row t4">
                        <div class="col t3"><b>Communication log</b></div>
                    </div>

                    <div class="scrollbar-AddEquipmentlog" id="style-AddEquipmentlog">
                        <div class="force-overflow-AddEquipmentlog">
                            <div class="row t4">
                                <div class="col t3">2024/02/26 14:00 P.M equipment connect successfully</div>
                            </div>
                            <div class="row t4">
                                <div class="col t3">2024/02/26 2:15 P.M equipment connect failed</div>
                            </div>
                        </div>
                    </div>

                    <div class="w3-center">
                        <button id="Add-GTCS" class="btn-Addsave" onclick="new_task_save()">Save</button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Add Socket tray -->
    <div class="modal" id="myModal">
        <div class="modal-dialog">
            <div class="modal-content w3-animate-zoom">
                <header class="modal-header">
                    <h4 id="modal_head" >Add Socket tray</h4>
                    <span class="close w3-display-topright">&times;</span>
                </header>
                <div class="modal-body">
                    <div class="row t4">
                        <div class="col-2 t3">Name:</div>
                        <div class="col-4 t4">
                            <input type="text" class="t5 form-control input-ms" id="socket-tray-name" maxlength="" required>
                        </div>
                    </div>

                    <hr style="color: #000;border: 0.5px solid #000;">

                    <div>
                        <label style="font-size: 18px">
                            <img style="height: 25px; width: 25px" class="images" src="./img/connection-control.svg" alt="">&nbsp;
                            <b>Connection control</b>
                        </label>
                    </div>
                    <div class="row t3">
                        <div class="col-6 t4 form-check form-check-inline">
                            <input class="form-check-input" type="radio" name="PLC" id="PLC" value="1" style="zoom:1.0; vertical-align: middle">&nbsp;
                            <label class="form-check-label" for="PLC">PLC</label>
                        </div>
                    </div>

                    <div class="row t3">
                        <div class="col-1 t3">1</div>
                        <div class="col t4" style=" margin-right: 3px">
                            <select id="unit" style="width: 60px" class="t4">
                                <option value="1">pin1</option>
                                <option value="2">pin2</option>
                                <option value="3">pin3</option>
                                <option value="4">pin4</option>
                                <option value="5">pin5</option>
                                <option value="6">pin6</option>
                            </select>
                        </div>
                    </div>

                    <div class="row t3">
                        <div class="col-1 t3">2</div>
                        <div class="col t4">
                            <select id="unit" style="width: 60px" class="t4">
                                <option value="1">pin1</option>
                                <option value="2">pin2</option>
                                <option value="3">pin3</option>
                                <option value="4">pin4</option>
                                <option value="5">pin5</option>
                                <option value="6">pin6</option>
                            </select>
                        </div>
                    </div>

                    <div class="row t3">
                        <div class="col-1 t3">3</div>
                        <div class="col t4">
                            <select id="unit" style="width: 60px" class="t4">
                                <option value="1">pin1</option>
                                <option value="2">pin2</option>
                                <option value="3">pin3</option>
                                <option value="4">pin4</option>
                                <option value="5">pin5</option>
                                <option value="6">pin6</option>
                            </select>
                        </div>
                    </div>

                    <div class="row t3">
                        <div class="col-1 t3">4</div>
                        <div class="col t4">
                            <select id="unit" style="width: 60px" class="t4">
                                <option value="1">pin1</option>
                                <option value="2">pin2</option>
                                <option value="3">pin3</option>
                                <option value="4">pin4</option>
                                <option value="5">pin5</option>
                                <option value="6">pin6</option>
                            </select>
                        </div>
                    </div>

                    <div class="row t3">
                        <div class="col-1 t3">5</div>
                        <div class="col t4">
                            <select id="unit" style="width: 60px" class="t4">
                                <option value="1">pin1</option>
                                <option value="2">pin2</option>
                                <option value="3">pin3</option>
                                <option value="4">pin4</option>
                                <option value="5">pin5</option>
                                <option value="6">pin6</option>
                            </select>
                        </div>
                    </div>

                    <hr style="color: #000;border: 0.5px solid #000; padding: 0">

                    <div>
                        <label style="font-size: 18px">
                            <img style="height: 25px; width: 25px" class="images" src="./img/test-adjust.png" alt="">&nbsp;
                            <b>Test adjust</b>
                        </label>
                    </div>
                    <div class="row t3">
                        <div class="col-5 t4 Sockettray" style="display: flex;">
                            <input type="text" id="Socket-tray1" value="1" class="form-control input-ms socket-tray" disabled="disabled">
                            <input type="text" id="Socket-tray2" value="2" class="form-control input-ms socket-tray" disabled="disabled">
                            <input type="text" id="Socket-tray3" value="3" class="form-control input-ms socket-tray" disabled="disabled">
                            <input type="text" id="Socket-tray4" value="4" class="form-control input-ms socket-tray" disabled="disabled" style="background-color: red">
                            <input type="text" id="Socket-tray5" value="5" class="form-control input-ms socket-tray" disabled="disabled">
                        </div>
                        <div class="col">
                            <button type="button" class="btn-Test" style="float: right">test</button>
                        </div>
                    </div>
                    <div class="row t4">
                        <div class="col-3 t3">Status:
                            <label style="color: red; padding-left: 5%"> offline/online</label>
                        </div>
                    </div>
                    <div class="row t4">
                        <div class="col t3"><b>Communication log</b></div>
                    </div>

                    <div class="scrollbar-AddEquipmentlog" id="style-AddEquipmentlog">
                        <div class="force-overflow-AddEquipmentlog">
                            <div class="row t4">
                                <div class="col t3">2024/02/26 14:00 P.M equipment connect successfully</div>
                            </div>
                            <div class="row t4">
                                <div class="col t3">2024/02/26 2:15 P.M equipment connect failed</div>
                            </div>
                        </div>
                    </div>

                    <div class="w3-center">
                        <button id="Add-SocketTray" class="btn-Addsave" onclick="new_task_save()">Save</button>
                    </div>
                </div>
            </div>
        </div>
    </div>


