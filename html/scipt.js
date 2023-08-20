$(document).ready(function() {
    const cameraView = document.getElementById("cameraView");
    const closeBtn = document.getElementById("closeBtn");
    const loginContainer = document.getElementById("login-container");
    const errorBox = document.getElementById("error");

    window.addEventListener("message", function(event) {
        if (event.data.action === "show_camera") {
            cameraView.style.display = "block";
        }
        else if (event.data.action === "hide_camera") {
            cameraView.style.display = "none";
        }

        else if (event.data.action === "show_login") {
            errorBox.style.display = "block";
            errorBox.innerHTML = "<h1>Trying to show login but error</h1>";
            $.post("http://FiveCCTV/JSDebug", JSON.stringify({ "message": "Trying to show login" }), () => {});
            loginContainer.style.display = "block";
        }
        else if (event.data.action === "hide_login") {
            $.post("http://FiveCCTV/JSDebug", JSON.stringify({ "message": "Trying to hide login" }), () => {});
            loginContainer.style.display = "none";
        }
    });

    closeBtn.addEventListener("click", function() {
        cameraView.style.display = "none";
        $.post("http://FiveCCTV/closeCamera", JSON.stringify({}), function(data) {
            // Handle callback response if needed
        });
    });

    const loginBtn = document.querySelector('.login-button');

    loginBtn.addEventListener(
        "click",
        function() {
            const cameraView = document.getElementById("cameraView");
            const loginContainer = document.getElementById("login-container");

            $.post(
                "http://FiveCCTV/validateLogin",
                JSON.stringify({
                    "ip": document.querySelector('.login-input:nth-child(1)').value,
                    "username": document.querySelector('.login-input:nth-child(2)').value,
                    "password": document.querySelector('.login-input:nth-child(3)').value
                }),
                function (data) {
                    if (data == "true") {
                        cameraView.style.display = "block";
                        loginContainer.style.display = "none";
                    } else {
                        alert("Invalid login credentials");
                    }
                }
            )
        }
    );
});
