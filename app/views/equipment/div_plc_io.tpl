<!-- PLC Input Output Setting -->
    <div id="PLC_In_Out_Setting" style="display: none">
        <div class="topnav">
            <label type="text" style="font-size: 20px; margin: 4px; padding-left: 5%">PLC Setting</label>
            <button class="btn" id="back-btn" type="button" onclick="cancelSetting()">
                <img id="img-back" src="./img/back.svg" alt="">back
            </button>
        </div>

        <div class="center-content">
            <div class="container">
                <div style="padding: 0px">
                    <div style="padding-left: 5%; padding-bottom: 1%">
                        <label style="font-size: 20px">
                            <img style="height: 30px; width: 30px" class="images" src="./img/in-output.png" alt="">&nbsp;
                            <b>Input and output</b>
                        </label>
                    </div>
                    <div style="padding-left: 10%">
                        <label style="font-size: 18px; margin-right: 15px"><b>Equiment :</b></label>
                        <button class="w3-button w3-light-grey">All</button>
                        <button class="w3-button w3-light-grey">Light</button>
                        <button class="w3-button w3-light-grey">button</button>
                        <button class="w3-button w3-light-grey">Socket tray</button>
                        <button class="w3-button w3-light-grey">Buzzer</button>
                    </div>
                    <div id="In-Output-Setting">
                        <div class="left-middle-right-header" style="padding-left: 12%">
                            <div class="left-column-input">
                                <h4 class="header-input">Input</h4>
                            </div>
                            <div class="middle-pin">
                                <h4 class="header-PIN"></h4>
                            </div>
                            <div class="right-column-output">
                                <h4 class="header-output">Output <a style="float: right; font-size: 18px; margin-right: 13%; margin-top: 2px">Unit test</a></h4>
                            </div>
                        </div>

                        <div class="scrollbar-IO" id="style-IO">
                            <div class="force-overflow-IO">
                                <div class="left-middle-right-IO" style="padding-left: 12%">
                                    <div class="left-column-input" style=" background-color: #CCCCCC">
                                        <div class="input-pin">
                                            <label>light</label>
                                            <label>light</label>
                                            <label>light</label>
                                            <label>button</label>
                                            <label>buzzer</label>
                                            <label></label>
                                            <label>socket tray</label>
                                            <label>socket tray</label>
                                            <label>socket tray</label>
                                            <label></label>
                                            <label></label>
                                            <label></label>
                                            <label></label>
                                            <label></label>
                                            <label></label>
                                            <label></label>
                                        </div>
                                    </div>

                                    <div class="middle-pin">
                                        <div class="pin">
                                            <label>1</label>
                                            <label>2</label>
                                            <label>3</label>
                                            <label>4</label>
                                            <label>5</label>
                                            <label>6</label>
                                            <label>7</label>
                                            <label>8</label>
                                            <label>9</label>
                                            <label>10</label>
                                            <label>11</label>
                                            <label>12</label>
                                            <label>13</label>
                                            <label>14</label>
                                            <label>15</label>
                                            <label>16</label>
                                        </div>
                                    </div>

                                    <div class="right-column-output" style=" background-color: #CCCCCC">
                                        <div class="output-pin">
                                            <label>light
                                                <input class="form-check-input" type="radio" name="output-option" checked="checked" id="" value="">
                                            </label>
                                            <label>light
                                                <input class="form-check-input" type="radio" name="output-option" id="" value="">
                                            </label>
                                            <label>light
                                                <input class="form-check-input" type="radio" name="output-option" id="" value="">
                                            </label>
                                            <label>button
                                                <input class="form-check-input" type="radio" name="output-option" id="" value="">
                                            </label>
                                            <label>buzzer
                                                <input class="form-check-input" type="radio" name="output-option" id="" value="">
                                            </label>
                                            <label>
                                                <input class="form-check-input" type="radio" name="output-option" id="" value="">
                                            </label>
                                            <label>socket tray
                                                <input class="form-check-input" type="radio" name="output-option" id="" value="">
                                            </label>
                                            <label>socket tray
                                                <input class="form-check-input" type="radio" name="output-option" id="" value="">
                                            </label>
                                            <label>socket tray

                                                <input class="form-check-input" type="radio" name="output-option" id="" value=""></label>
                                            <label>
                                                <input class="form-check-input" type="radio" name="output-option" id="" value="">
                                            </label>
                                            <label>
                                                <input class="form-check-input" type="radio" name="output-option" id="" value="">
                                            </label>
                                            <label>
                                                <input class="form-check-input" type="radio" name="output-option" id="" value="">
                                            </label>
                                            <label>
                                                <input class="form-check-input" type="radio" name="output-option" id="" value="">
                                            </label>
                                            <label>
                                                <input class="form-check-input" type="radio" name="output-option" id="" value="">
                                            </label>
                                            <label>
                                                <input class="form-check-input" type="radio" name="output-option" id="" value="">
                                            </label>
                                            <label>
                                                <input class="form-check-input" type="radio" name="output-option" id="" value="">
                                            </label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <button class="saveButton" id="saveButton">Save</button>
                </div>
            </div>
        </div>
    </div>