resource "datadog_dashboard_json" "dashboard_json" {
       dashboard = file("./resources/storedog_dashboard.json") # Built on Datadog and exported as JSON
}