var CUSTOM_JOB = (function(cj, $) {

  var submit_job = function() {
    $.ajax({
      url: '/custom_jobs',
      type: 'post',
      data: $('#create_custom_job_form').serialize(),
      success: function(data) {
        var job_id = data.job_id;
        alert('Job ID ' + job_id + ' was successfully submitted');
        DELAYED_JOB_ADMIN.poll_job(job_id, on_job_success, on_job_failure);
      },
      dataType: 'json'
    });
  };

  var on_job_success = function() {
    alert('Job was successfully completed');
    //alert('Job with ID ' + data.job_id + 'was successfully completed');
  }

  var on_job_failure = function() {
    alert('Job failed');
  };

  cj.init = function() {
    $('#submit_custom_job').click(submit_job);
  };

  return cj;
})(CUSTOM_JOB || {}, jQuery);

$(document).ready(function() {
  CUSTOM_JOB.init();
});
