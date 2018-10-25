$(function(){
  $('.editable').on('focusout', function() {
    var reportId = $(this).attr('report_id');
    if(reportId) {
      var reportProps = stringToReportProperties($("#report_" + reportId + "_properties").val());
      var location = $("#report_" + reportId + "_location").val();

      var reportParams = {
        report: {
          location: location,
          properties: reportProps
        }
      }

      var url = app_url + "/reports/" + reportId + ".json";
      $.post({
        method: 'PUT',
        url: url, 
        contentType:"application/json; charset=utf-8",
        data: JSON.stringify(reportParams),
        dataType: "json",
      });
    }
  });
});

function stringToReportProperties(string) {
  var support_delimeters = [";", "\n"];
  var delimeter = '\n';

  support_delimeters.forEach(function(del) {
    if(string.includes(del)){
      delimeter = del;
    }
  });

  var reports = [];
  var properties = string.split(delimeter);

  properties.forEach(function(property) {
    report = stringToReportProperty(property);
    if(report){
      reports.push(report);
    }
  });

  return reports;
}

function stringToReportProperty(string) {
  var report = null;
  var regex = string.match(/^\s*case:(\d)\W*\s*symptom:\s*(\D*)/);
  if(regex && regex.length >= 3){
    report = {
      case: regex[1],
      symptom: JSON.parse(regex[2])
    }
  }
  return report;
}
