$(document).ready(function() {
    const cameraView = document.getElementById("cameraView");
    const loginContainer = document.getElementById("login-container");
    const errorBox = document.getElementById("error");

    function log(message) {
        errorBox.textContent = "";
        errorBox.textContent += "\n" + message;
    }

    window.addEventListener("message", function(event) {
        if (event.data.action === "show_camera") {
            cameraView.style.display = "block";
        }
        else if (event.data.action === "hide_camera") {
            cameraView.style.display = "none";
        }

        else if (event.data.action === "show_login") {
            loginContainer.style.display = "block";
        }
        else if (event.data.action === "hide_login") {
            loginContainer.style.display = "none";
        }
    });

    const loginBtn = document.getElementById("login-button");

    $("#login-button").on(
        "click",
        function () {
            console.log("Attempting to log in");
            data = JSON.stringify({
                ip: $('#ip').val(),
                username: $('#username').val(),
                password: $('#password').val()
            });
            console.log(data);
            $.post(
                "http://FiveCCTV/validateLogin",
                data
            )
        }
    );
});
