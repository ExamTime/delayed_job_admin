var DELAYED_JOB_ADMIN = (function(dja, $) {
  dja.init = function() {
    //$('table.delayed_job_admin_jobs').dataTable();
    $('td .delayed_job_admin_toggle_info').click(toggle_info);
  };

  var toggle_info = function() {
    var td_el = $(this).closest('td');
    if( td_el.find('.delayed_job_admin_value').hasClass('hidden') ) {
      // Collapsed so expand
      td_el.find('.delayed_job_admin_display_value').addClass('hidden');
      td_el.find('.delayed_job_admin_value').removeClass('hidden');
    } else {
      // Expanded so collapse
      td_el.find('.delayed_job_admin_value').addClass('hidden');
      td_el.find('.delayed_job_admin_display_value').removeClass('hidden');
    }
  };

  return dja;
})(DELAYED_JOB_ADMIN || {}, jQuery);

$(document).ready(function() {
  DELAYED_JOB_ADMIN.init();
});
