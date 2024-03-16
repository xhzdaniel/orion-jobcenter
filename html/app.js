Open = function (jobs) {
    SetJobs(jobs);
    $(".container").fadeIn(150);
};

Close = function () {
    $(".container").fadeOut(150, function () {
        ResetPages();
    });
    $.post("https://orion-jobcenter/close");
};

SetJobs = function (jobs, playerJob) {
    $(".job-page-blocks").empty();
    let playerBoolean = false;
    $.each(jobs, (job, data) => {
        if (job == playerJob) { playerBoolean = true } else { playerBoolean = false };
        let html = `<div class="job-page-block"><h3>${data.label}</h3><img src="${data.icon}">
        ${playerBoolean ? `<div class="remove-job button" data-job="${job}" data-label="${data.label}"><p>Remove</p></div>` : `<div class="apply-job button" data-job="${job}" data-label="${data.label}"><p>Apply</p></div>`}
        </div>`;
        $(".job-page-blocks").append(html);
    });
};

ResetPages = function () {
    $.post('https://orion-jobcenter/updateJobs');
};

$(document).ready(function () {
    window.addEventListener("message", function (event) {
        switch (event.data.action) {
            case "open":
                Open(event.data.jobs);
                break;
            case "close":
                Close();
                break;
            case "setJobs":
                SetJobs(event.data.jobs, event.data.playerJob);
                break;
        }
    });
});

$(document).on("keydown", function (event) {
    switch (event.keyCode) {
        case 27: // ESC
            Close();
            break;
    }
});

$(document).on("click", ".apply-job", function (e) {
    e.preventDefault();
    const data = {
        job: $(this).data("job"),
        label: $(this).data("label")
    };
    $.post("https://orion-jobcenter/applyJob", JSON.stringify(data));
    ResetPages();
});

$(document).on('click', '.remove-job', function (e) {
    e.preventDefault();
    const data = {
        job: $(this).data("job"),
        label: $(this).data("label")
    };
    $.post("https://orion-jobcenter/removeJob", JSON.stringify(data));
    ResetPages();
});

$(document).on("wheel", ".job-page-blocks", function () {
    const element = document.querySelector('.job-page-blocks');
    let [x, y] = [event.deltaX, event.deltaY];
    let magnitude;
    if (x === 0) {
        magnitude = y > 0 ? -30 : 30;
    } else {
        magnitude = x;
    }
    element.scrollBy({
        left: magnitude
    });
});