<!-- Pick To Light Edit Setting -->
    <div id="PickToLight_Edit_Setting" style="display: none">
        <div class="topnav">
            <label type="text" style="font-size: 20px; margin: 4px; padding-left: 5%">Pick-To-Light Setting</label>
            <button class="btn" id="back-btn" type="button" onclick="cancelSetting()">
                <img id="img-back" src="./img/back.svg" alt="">back
            </button>
        </div>
        <div class="center-content">
            <div class="container">
                <div class="wrapper" style="top: 0">
                    <div class="navbutton active" onclick="handleButtonClick(this, 'picktolight')">
                        <span data-content="Connect setting" onclick="showContent('picktolight')"></span>Connect setting
                    </div>
                    <div class="navbutton" onclick="handleButtonClick(this, 'picktolightsetting')">
                        <span data-content="Light setting" onclick="showContent('picktolightsetting')"></span>Light setting
                    </div>
                </div>

                <div id="picktolightContent" class="content">
                    <div style="padding-left: 7%; padding: 50px">
                        <div class="row t1">
                            <div class="col-1 t3">Name :</div>
                            <div class="col-2 t2">
                                <input type="text" id="connect-name" class="t5 form-control input-ms" value="" maxlength="">
                            </div>
                        </div>

                        <div style="padding: 5px">
                            <label style="font-size: 18px">
                                <img style="height: 25px; width: 25px" class="images" src="./img/connection-control.svg" alt="">&nbsp;
                                <b>Connection control</b>
                            </label>
                        </div>
                        <div class="row t3">
                            <div class="col-2 t4 form-check form-check-inline">
                                <input class="form-check-input" type="radio" name="connection-control" id="Device-RS232" value="1" style="zoom:1.2; vertical-align: middle">&nbsp;
                                <label class="form-check-label" for="Device-RS232">Modbus RTU/RS232</label>
                            </div>
                        </div>

                        <div class="row t3">
                            <div class="col-1 t3">
                                <select id="unit" style="width: 110px">
                                    <option value="1">com 3</option>
                                    <option value="2">com 5</option>
                                </select>
                            </div>
                            <div class="col-1 t3">
                                <select id="unit" style="width: 110px">
                                    <option value="1">115200</option>
                                    <option value="2">57600</option>
                                    <option value="3">38400</option>
                                    <option value="4">9600</option>
                                    <option value="5">4800</option>
                                    <option value="6">2400</option>
                                    <option value="7">1200</option>
                                </select>
                            </div>
                            <div class="col-1 t3">
                                <select id="unit" style="width: 110px">
                                    <option value="1">None</option>
                                    <option value="2">Odd</option>
                                    <option value="2">Even</option>
                                    <option value="2">Mark</option>
                                    <option value="2">Space</option>
                                </select>
                            </div>
                            <div class="col-1 t3">
                                <select id="unit" style="width: 110px">
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
                            <div class="col-1 t3">
                                <select id="unit" style="width: 110px">
                                    <option value="1">10</option>
                                    <option value="2">4</option>
                                    <option value="3">1</option>
                                    <option value="4">3</option>
                                </select>
                            </div>
                        </div>
                        <div class="row t3">
                            <div class="col-3 t4 form-check form-check-inline">
                                <input class="form-check-input" type="radio" name="connection-control" id="Device-TCP-IP" value="1" onclick="EquipmentCheckbox('gtcs')" style="zoom:1.2; vertical-align: middle">&nbsp;
                                <label class="form-check-label" for="Device-TCP-IP">TCP/IP</label>
                            </div>
                        </div>
                        <div class="row t4">
                            <div class="col-2 t3">Network IP:</div>
                            <div class="col-2 t4" style="margin-left: -5%">
                                <input type="text" class="t5 form-control input-ms" id="Network-IP" value="192.168.0.184" maxlength="" required>
                            </div>
                            <div class="col-1 t3">Port:</div>
                            <div class="col-1 t4">
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
                                <button type="button" class="btn btn-Reconnect">Reconnect</button>
                            </div>
                        </div>
                        <div class="row t4">
                            <div class="col t3"><b>Communication log</b></div>
                        </div>
                        <div class="scrollbar-Communicationlog" id="style-Communicationlog">
                            <div class="force-overflow-Communicationlog">
                                <div class="row t4">
                                    <div class="col t3">2024/02/26 14:00 P.M equipment connect successfully</div>
                                </div>
                                <div class="row t4">
                                    <div class="col t3">2024/02/26 2:15 P.M equipment connect failed</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div id="picktolightsettingContent" class="content" style="display: none">
                    <div class="label-text" style="padding-left: 7%; padding: 50px">
                        <div style="padding: 5px">
                            <label style="font-size: 18px">
                                <img style="height: 25px; width: 25px" class="images" src="./img/connection-control.svg" alt="">&nbsp;
                                    Light Setting
                            </label>
                        </div>
                    </div>
                </div>
                <button class="saveButton" id="saveButton">Save</button>
            </div>
        </div>
    </div>