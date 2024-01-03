document.addEventListener("DOMContentLoaded", function () {
    
    const dbview = document.getElementById("dbview");

    if (!dbview) {
        return;
    }

    dbview.addEventListener("click", function (event) {

        const date = new Date();

        const formattedDate = date.toLocaleString('de-DE');

        event.target.dispatchEvent(new CustomEvent("notify", {
            bubbles: true,
            detail: {
                text: formattedDate + " - DBView!"
            },
        }));

    });

});
