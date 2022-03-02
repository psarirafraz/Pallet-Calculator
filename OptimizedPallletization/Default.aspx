<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="OptimizedPallletization._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <div id="maindiv" class="container-fluid">
        <div class="col-md-4">
            <div class="form-group">
                <label>Length of the Box</label>
                <input type="number" class="form-control" id="lengthOfBox" placeholder="Length of Each box">
            </div>
            <div class="form-group">
                <label>Width of the Box</label>
                <input type="number" class="form-control" id="widthOfBox" placeholder="Width of Each box">
            </div>
            <div class="form-group">
                <label>Height of the Box</label>
                <input type="number" class="form-control" id="heightOfBox" placeholder="Height of Each box">
            </div>
            <div class="form-group">
                <label>weight Of the Box</label>
                <input type="number" class="form-control" id="weightOfBox" placeholder="weight Of Each Box">
            </div>
            <div class="form-group">
                <label>Number Of the Box</label>
                <input type="number" class="form-control" id="numberOfBox" placeholder="Number Of Each Box">
            </div>
            <div class="form-group">
                <label>Unit of Measure</label>
                <select id="BoxMeasurementUnit" class="form-control">
                    <option>in</option>
                    <option>cm</option>
                    <option>meter</option>
                    <option>feet</option>
                </select>
            </div>
            <div class="form-group">
                <label>Unit of weight</label>
                <select id="BoxweightUnit" class="form-control">
                    <option>lb</option>
                    <option>kg</option>
                    <option>Ounce</option>
                    <option>Gram</option>
                </select>
            </div>
        </div>
        <div class="col-md-4">
            <div class="form-group">
                <label>Length of the Pallet</label>
                <input type="number" class="form-control" id="lengthOfPallet" placeholder="Length of the Pallet" value="48">
            </div>
            <div class="form-group">
                <label>Width of the Pallet</label>
                <input type="number" class="form-control" id="widthOfPallet" placeholder="Width of the Pallet" value="40">
            </div>
            <div class="form-group">
                <label>Maximum Height of the Pallet</label>
                <input type="number" class="form-control" id="maximumHeightOfPallet" placeholder="Maximum Height of the Pallet" value="60">
            </div>
            <div class="form-group">
                <label>Maximum weight of the Pallet</label>
                <input type="number" class="form-control" id="maximumweightOfPallet" placeholder="Maximum weight of the Pallet" value="2500">
            </div>
            
            <div class="form-group">
                <label>Unit of Measure</label>
                <select id="PalletMeasurementUnit" class="form-control">
                    <option>in</option>
                    <option>cm</option>
                    <option>meter</option>
                    <option>feet</option>
                </select>
            </div>
            <div class="form-group">
                <label>Unit of weight</label>
                <select id="PalletweightUnit" class="form-control">
                    <option>lb</option>
                    <option>kg</option>
                    <option>Ounce</option>
                    <option>Gram</option>
                </select>
            </div>
        </div>
        <div class="col-md-4">
            <div class="row Calculated-Var">
                <h5 class="col-md-6">Pallet Area</h5>
                <h5 class="col-md-6" id="PalletArea"></h5>
            </div>
            <div class="row Calculated-Var">
                <h5 class="col-md-6">Box Area</h5>
                <h5 class="col-md-6" id="BoxArea"></h5>
            </div>
            <div class="row Calculated-Var">
                <h5 class="col-md-6">Box Count Per Layer</h5>
                <h5 class="col-md-6" id="BoxCount"></h5>
            </div>
            <div class="row Calculated-Var">
                <h5 class="col-md-6">Number of Layers</h5>
                <h5 class="col-md-6" id="Layers"></h5>
            </div> 
            <div class="row Calculated-Var">
                <h5 class="col-md-6">Total Number of Boxs</h5>
                <h5 class="col-md-6" id="TotalBoxes"></h5>
            </div>
            <div class="row Calculated-Var">
                <h5 class="col-md-6">Total weight</h5>
                <h5 class="col-md-6" id="Totalweight"></h5>
            </div>
            <div class="row Calculated-Var">
                <h5 class="col-md-6">Row Count</h5>
                <h5 class="col-md-6" id="RowCount"></h5>
            </div>
            <div class="row Calculated-Var">
                <h5 class="col-md-6">Col Count</h5>
                <h5 class="col-md-6" id="ColCount"></h5>
            </div>
            <div class="row Calculated-Var">
                <h5 class="col-md-6">Odd Row Count</h5>
                <h5 class="col-md-6" id="OddRowCount"></h5>
            </div>
            <div class="row Calculated-Var">
                <h5 class="col-md-6">Odd Col Count</h5>
                <h5 class="col-md-6" id="OddColCount"></h5>
            </div>
        </div>
        
    </div>
    <div id="SideView" class="container">
    </div>
    <script src="Scripts/three.js"></script>
    <script>

        function GetTotalBoxCount(palletWidth, palletLength, boxLength, boxWidth) {
            
            let TotalBoxesInBasicRows = 0;
            let TotalBoxesInOddRow = 0;

            let basicRowCount = parseInt(palletLength / boxLength);
            let basicColCount = parseInt(palletWidth / boxWidth);
            let basicOddRowCount = 0;
            let basicOddColCount = 0;

            TotalBoxesInBasicRows = basicRowCount * basicColCount;

            if (parseInt(palletLength % boxLength) >= boxWidth && boxLength <= palletWidth) {
                basicOddRowCount = parseInt(parseFloat(palletLength % boxLength) / boxWidth);
                basicOddColCount = parseInt(palletWidth / boxLength);
                TotalBoxesInOddRow = basicOddRowCount * basicOddColCount;
            }

            
            return [(TotalBoxesInBasicRows + TotalBoxesInOddRow), basicRowCount, basicColCount, basicOddRowCount, basicOddColCount];
        }

        let NumberOfboxesOnEachLayer = 0;

        let bestFitLength = 0;
        let bestFitWidth = 0;

        let RowNumbers = 0;
        let ColNumbers = 0;
        let OddRowNumbers = 0;
        let OddColNumbers = 0;

        let totalNumberOfBoxes;
        let LimitedNumberOfLayers;

        let weightUnitChange;

        var lengthOfBox = parseFloat(document.getElementById("lengthOfBox").value);
        var widthOfBox = parseFloat(document.getElementById("widthOfBox").value);
        var heightOfBox = parseFloat(document.getElementById("heightOfBox").value);
        var weightOfBox = parseFloat(document.getElementById("weightOfBox").value);
        var numberOfBox = parseInt(document.getElementById("numberOfBox").value);

        var BoxMeasurementUnit = document.getElementById("BoxMeasurementUnit").value;
        var BoxweightUnit = document.getElementById("BoxweightUnit").value;

        //Pallet info
        var lengthOfPallet = parseFloat(document.getElementById("lengthOfPallet").value);
        var widthOfPallet = parseFloat(document.getElementById("widthOfPallet").value);
        var maximumHeightOfPallet = parseFloat(document.getElementById("maximumHeightOfPallet").value);
        var maximumweightOfPallet = parseFloat(document.getElementById("maximumweightOfPallet").value);

        var PalletMeasurementUnit = document.getElementById("PalletMeasurementUnit").value;
        var PalletweightUnit = document.getElementById("PalletweightUnit").value;

        function CalculateBoxCounts() {
            //const
            const convFactor = 3;
            const pointsPerInch = 72;

            const inchPerCM = 0.393701;
            const inchPerMeter = 39.3701;
            const inchPerFoot = 12;

            const ouncePerLb = 16;
            const ouncePerKg = 35.27396;
            const ouncePerGram = 0.0352739;



            //Box info
            lengthOfBox = parseFloat(document.getElementById("lengthOfBox").value);
            widthOfBox = parseFloat(document.getElementById("widthOfBox").value);
            heightOfBox = parseFloat(document.getElementById("heightOfBox").value);
            weightOfBox = parseFloat(document.getElementById("weightOfBox").value);
            numberOfBox = parseFloat(document.getElementById("numberOfBox").value);

            BoxMeasurementUnit = document.getElementById("BoxMeasurementUnit").value;
            BoxweightUnit = document.getElementById("BoxweightUnit").value;

            //Pallet info
            lengthOfPallet = parseFloat(document.getElementById("lengthOfPallet").value);
            widthOfPallet = parseFloat(document.getElementById("widthOfPallet").value);
            maximumHeightOfPallet = parseFloat(document.getElementById("maximumHeightOfPallet").value);
            maximumweightOfPallet = parseFloat(document.getElementById("maximumweightOfPallet").value);

            PalletMeasurementUnit = document.getElementById("PalletMeasurementUnit").value;
            PalletweightUnit = document.getElementById("PalletweightUnit").value;

            switch (BoxMeasurementUnit) {
                case "in":
                    break;
                case "cm":
                    lengthOfBox = lengthOfBox * inchPerCM;
                    widthOfBox = widthOfBox * inchPerCM;
                    heightOfBox = heightOfBox * inchPerCM;
                    break;
                case "meter":
                    lengthOfBox = lengthOfBox * inchPerMeter;
                    widthOfBox = widthOfBox * inchPerMeter;
                    heightOfBox = heightOfBox * inchPerMeter;
                    break;
                case "feet":
                    lengthOfBox = lengthOfBox * inchPerFoot;
                    widthOfBox = widthOfBox * inchPerFoot;
                    heightOfBox = heightOfBox * inchPerFoot;
                    break;
            }

            switch (PalletMeasurementUnit) {
                case "in":
                    break;
                case "cm":
                    lengthOfPallet = lengthOfPallet * inchPerCM;
                    widthOfPallet = widthOfPallet * inchPerCM;
                    maximumHeightOfPallet = maximumHeightOfPallet * inchPerCM;
                    break;
                case "meter":
                    lengthOfPallet = lengthOfPallet * inchPerMeter;
                    widthOfPallet = widthOfPallet * inchPerMeter;
                    maximumHeightOfPallet = maximumHeightOfPallet * inchPerMeter;
                    break;
                case "feet":
                    lengthOfPallet = lengthOfPallet * inchPerFoot;
                    widthOfPallet = widthOfPallet * inchPerFoot;
                    maximumHeightOfPallet = maximumHeightOfPallet * inchPerFoot;
                    break;
            }
            if (BoxweightUnit != PalletweightUnit) {
                weightUnitChange = true;
                switch (BoxweightUnit) {
                    case "lb":
                        weightOfBox = weightOfBox * ouncePerLb;
                        break;
                    case "kg":
                        weightOfBox = weightOfBox * ouncePerKg;
                        break;
                    case "Gram":
                        weightOfBox = weightOfBox * ouncePerGram;
                        break;
                    case "Ounce":

                }

                switch (PalletweightUnit) {
                    case "lb":
                        maximumweightOfPallet = maximumweightOfPallet * ouncePerLb;
                        break;
                    case "kg":
                        maximumweightOfPallet = maximumweightOfPallet * ouncePerKg;
                        break;
                    case "Gram":
                        maximumweightOfPallet = maximumweightOfPallet * ouncePerGram;
                        break;
                    case "Ounce":

                }
            } else {
                weightUnitChange = false;
            }

            

            let TotalBoxFrontSideOfBox = GetTotalBoxCount(widthOfPallet, lengthOfPallet, widthOfBox, lengthOfBox);
            let TotalBoxSideWayOfBox = GetTotalBoxCount(widthOfPallet, lengthOfPallet, lengthOfBox, widthOfBox);

            

            if (TotalBoxFrontSideOfBox[0] >= TotalBoxSideWayOfBox[0]) {
                NumberOfboxesOnEachLayer = TotalBoxFrontSideOfBox[0];
                RowNumbers = TotalBoxFrontSideOfBox[2];
                ColNumbers = TotalBoxFrontSideOfBox[1];
                OddRowNumbers = TotalBoxFrontSideOfBox[4];
                OddColNumbers = TotalBoxFrontSideOfBox[3];
                let temp = widthOfBox;
                widthOfBox = lengthOfBox;
                lengthOfBox = temp;
            } else if (TotalBoxFrontSideOfBox[0] < TotalBoxSideWayOfBox[0]) {
                NumberOfboxesOnEachLayer = TotalBoxSideWayOfBox[0];
                RowNumbers = TotalBoxSideWayOfBox[2];
                ColNumbers = TotalBoxSideWayOfBox[1];
                OddRowNumbers = TotalBoxSideWayOfBox[4];
                OddColNumbers = TotalBoxSideWayOfBox[3];
            }

            LimitedNumberOfLayers = parseInt(maximumHeightOfPallet / heightOfBox);

            totalNumberOfBoxes = NumberOfboxesOnEachLayer * LimitedNumberOfLayers;

            if (weightOfBox * (NumberOfboxesOnEachLayer * LimitedNumberOfLayers) > maximumweightOfPallet) {
                totalNumberOfBoxes = parseInt(maximumweightOfPallet / weightOfBox);
                LimitedNumberOfLayers = Math.ceil(totalNumberOfBoxes / NumberOfboxesOnEachLayer);
            }

            if (numberOfBox > 0 && numberOfBox < totalNumberOfBoxes) {
                totalNumberOfBoxes = numberOfBox;
                LimitedNumberOfLayers = Math.ceil(totalNumberOfBoxes / NumberOfboxesOnEachLayer);
            }

            document.getElementById("PalletArea").innerHTML = (lengthOfPallet * widthOfPallet > 0 ? lengthOfPallet * widthOfPallet : 0) + " inch";
            document.getElementById("BoxArea").innerHTML = (lengthOfBox * widthOfBox > 0 ? lengthOfBox * widthOfBox : 0) + " inch";
            document.getElementById("BoxCount").innerHTML = NumberOfboxesOnEachLayer > 0 ? NumberOfboxesOnEachLayer : 0;
            document.getElementById("Layers").innerHTML = LimitedNumberOfLayers > 0 ? LimitedNumberOfLayers : 0;
            document.getElementById("TotalBoxes").innerHTML = totalNumberOfBoxes > 0 ? totalNumberOfBoxes : 0;

            document.getElementById("RowCount").innerHTML = RowNumbers > 0 ? RowNumbers : 0;
            document.getElementById("ColCount").innerHTML = ColNumbers > 0 ? ColNumbers : 0;
            document.getElementById("OddRowCount").innerHTML = OddRowNumbers > 0 ? OddRowNumbers : 0;
            document.getElementById("OddColCount").innerHTML = OddColNumbers > 0 ? OddColNumbers : 0;
            

            if (weightUnitChange) {
                document.getElementById("Totalweight").innerHTML = ((weightOfBox * totalNumberOfBoxes) > 0 ? (weightOfBox * totalNumberOfBoxes) : 0) + " Ounce";
            } else {
                document.getElementById("Totalweight").innerHTML = ((weightOfBox * totalNumberOfBoxes) > 0 ? (weightOfBox * totalNumberOfBoxes) : 0)  +" "+PalletweightUnit;
            }
            
        }

        const scene = new THREE.Scene();

        scene.background = new THREE.Color(0xffffff);

        const divWidth = document.getElementById("maindiv").clientWidth;
        const divHeight = document.getElementById("maindiv").clientHeight;

        const camera = new THREE.PerspectiveCamera(75, divWidth / divHeight, 1, 1000);
        
        const renderer = new THREE.WebGLRenderer();
        renderer.setSize(divWidth, divHeight);

        document.getElementById("SideView").appendChild(renderer.domElement);

        let geometry = new THREE.BoxGeometry(lengthOfPallet, 1, widthOfPallet);
        let edges = new THREE.EdgesGeometry(geometry);
        let line = new THREE.LineSegments(edges, new THREE.LineBasicMaterial({ color: 0x000000 }));
        let material = new THREE.MeshBasicMaterial({ color: 0x3432a8 });
        let cube = new THREE.Mesh(geometry, material);

        camera.position.y = 30;
        
        camera.lookAt(scene.position);

        scene.add(cube);
        scene.add(line);

        const animate = function () {
            requestAnimationFrame(animate);

            //cube.rotation.x += 0.01;
            //cube.rotation.y += 0.01;

            renderer.render(scene, camera);
        };

        animate();

        CalculateBoxCounts();

        let Boxes = [];

        function onChange() {
            
            CalculateBoxCounts();
            
            scene.remove(cube);
            scene.remove(line);

            Boxes.forEach((item) => {
                scene.remove(item);
            });

            geometry = new THREE.BoxGeometry(lengthOfPallet, 1, widthOfPallet);
            edges = new THREE.EdgesGeometry(geometry);
            line = new THREE.LineSegments(edges, new THREE.LineBasicMaterial({ color: 0x000000 }));
            material = new THREE.MeshBasicMaterial({ color: 0x3432a8 });
            cube = new THREE.Mesh(geometry, material);

            camera.position.y = (LimitedNumberOfLayers * heightOfBox) + 40;
            camera.rotation.x = -1.55;

            scene.add(cube);
            scene.add(line);

            const safeDistance = 0.25;
            let cb = 0;
            

            for (let L = 0; L < LimitedNumberOfLayers; L++) {
                for (let c = 0; c < ColNumbers; c++) {
                    for (let r = 0; r < RowNumbers; r++) {

                        if (cb == totalNumberOfBoxes) {
                            break;
                        }
                        
                        
                        var SmallBox = new THREE.BoxGeometry(lengthOfBox - safeDistance, heightOfBox - safeDistance, widthOfBox - safeDistance);
                        var BoxEdges = new THREE.EdgesGeometry(SmallBox);
                        var BoxLine = new THREE.LineSegments(BoxEdges, new THREE.LineBasicMaterial({
                            color: 0x000000,
                            linewidth: 2,
                        }));
                        var BoxMaterial = new THREE.MeshBasicMaterial({ color: 0xa84c20 });
                        var WholeSmallBox = new THREE.Mesh(SmallBox, BoxMaterial);

                        WholeSmallBox.position.x = (-(lengthOfPallet / 2) + (lengthOfBox / 2) + ((c) * lengthOfBox));
                        WholeSmallBox.position.y = ((L * heightOfBox) + (heightOfBox / 2) + 0.5);
                        WholeSmallBox.position.z = (-(widthOfPallet / 2) + (widthOfBox / 2) + ((r) * widthOfBox));

                        BoxLine.position.x = (-(lengthOfPallet / 2) + (lengthOfBox / 2) + ((c) * lengthOfBox));
                        BoxLine.position.y = ((L * heightOfBox) + (heightOfBox / 2) + 0.5);
                        BoxLine.position.z = (-(widthOfPallet / 2) + (widthOfBox / 2) + ((r) * widthOfBox));


                        scene.add(WholeSmallBox);
                        scene.add(BoxLine);

                        Boxes.push(WholeSmallBox);
                        Boxes.push(BoxLine);
                        cb++;

                    }
                }

                for (let ro = 0; ro < OddRowNumbers; ro++) {
                    for (let co = 0; co < OddColNumbers; co++) {

                        if (cb == totalNumberOfBoxes) {
                            break;
                        }

                        var SmallBox = new THREE.BoxGeometry(widthOfBox - safeDistance, heightOfBox - safeDistance, lengthOfBox - safeDistance);
                        var BoxEdges = new THREE.EdgesGeometry(SmallBox);
                        var BoxLine = new THREE.LineSegments(BoxEdges, new THREE.LineBasicMaterial({
                            color: 0x000000,
                            linewidth: 2,
                        }));
                        var BoxMaterial = new THREE.MeshBasicMaterial({ color: 0xa84c00 });
                        var WholeSmallBox = new THREE.Mesh(SmallBox, BoxMaterial);

                        WholeSmallBox.position.z = (-(widthOfPallet / 2) + (lengthOfBox / 2) + (ro * lengthOfBox));
                        WholeSmallBox.position.y = ((L * heightOfBox) + (heightOfBox / 2) + 0.5);
                        WholeSmallBox.position.x = (-(lengthOfPallet / 2) + (widthOfBox / 2) + (co * widthOfBox) + (ColNumbers * lengthOfBox));

                        BoxLine.position.z = (-(widthOfPallet / 2) + (lengthOfBox / 2) + (ro * lengthOfBox));
                        BoxLine.position.y = ((L * heightOfBox) + (heightOfBox / 2) + 0.5);
                        BoxLine.position.x = (-(lengthOfPallet / 2) + (widthOfBox / 2) + (co * widthOfBox) + (ColNumbers * lengthOfBox));
                        
                        
                        

                        scene.add(WholeSmallBox);
                        scene.add(BoxLine);

                        Boxes.push(WholeSmallBox);
                        Boxes.push(BoxLine);

                        cb++;

                    }
                }
            }
        }
        
        document.getElementById("lengthOfBox").addEventListener("blur", onChange);
        document.getElementById("widthOfBox").addEventListener("blur", onChange);
        document.getElementById("heightOfBox").addEventListener("blur", onChange);
        document.getElementById("weightOfBox").addEventListener("blur", onChange);
        document.getElementById("numberOfBox").addEventListener("blur", onChange);
        document.getElementById("BoxMeasurementUnit").addEventListener("blur", onChange);
        document.getElementById("BoxweightUnit").addEventListener("blur", onChange);
        document.getElementById("lengthOfPallet").addEventListener("blur", onChange);
        document.getElementById("widthOfPallet").addEventListener("blur", onChange);
        document.getElementById("maximumHeightOfPallet").addEventListener("blur", onChange);
        document.getElementById("maximumweightOfPallet").addEventListener("blur", onChange);
        document.getElementById("PalletMeasurementUnit").addEventListener("blur", onChange);
        document.getElementById("PalletweightUnit").addEventListener("blur", onChange);
        
    </script>
</asp:Content>
