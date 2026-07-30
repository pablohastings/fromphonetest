(function () {
  var deployed = document.getElementById("deployed-at");
  var stamp = document.getElementById("build-stamp");

  if (deployed) {
    deployed.textContent = new Date().toISOString();
  }

  // Overwritten by upload.ps1 when deploying
  if (stamp && typeof window.__FTP_BUILD__ === "string") {
    stamp.textContent = window.__FTP_BUILD__;
  }
})();
