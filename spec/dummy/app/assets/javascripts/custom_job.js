var CUSTOM_JOB = (function(cj, $) {

  var $status_message = null;

  var submit_job = function() {
    $.ajax({
      url: '/custom_jobs',
      type: 'post',
      data: $('#create_custom_job_form').serialize(),
      success: function(data) {
        var job_id = data.job_id;
        $status_message.html('Job ID ' + job_id + ' has been queued');
        DELAYED_JOB_ADMIN.poll_job(job_id, on_job_success, on_job_failing, on_job_processing, 2);
      },
      dataType: 'json'
    });
  };

  var on_job_success = function(data) {
    $status_message.html('Job ID ' + data.job_id + ' has been successfully completed.');
  }

  var on_job_failing = function(data) {
    $status_message.html('Job ID ' + data.job_id + ' is failing.');
  };

  var on_job_processing = function(data) {
    $status_message.html('Job ID ' + data.job_id + ' is currently being processed ...');
  };

  cj.init = function() {
    $('#submit_custom_job').click(submit_job);
    $status_message = $('#status_message');
  };

  return cj;
})(CUSTOM_JOB || {}, jQuery);

$(document).ready(function() {
  CUSTOM_JOB.init();
});
