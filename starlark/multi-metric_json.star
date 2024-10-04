load("json.star", "json")

def apply(metric):
    metrics = []
    for group in json.decode(metric.fields.get("value")):

            # Get cpu, ram, disk, and chassis metrics
            for metric_key in ["cpuHealthMetrics", "memoryHealthMetrics", "diskHealthMetrics", "chassisStatsHealthMetrics"]:
                new_metric = Metric("ftd_"+ metric_key)
                for name,value in group.get(metric_key, {}).items():
                    new_metric.fields[name] = value
                new_metric.tags["deviceUid"] =  group["deviceUid"]
                new_metric.tags["deviceName"] =  group["deviceName"]
                metrics.append(new_metric)

            # Process interface metrics (We may need to break up int and str values...)
            for if_data in group.get("interfaceHealthMetrics", {}):
                new_int_metric = Metric("ftd_interfaceHealthMetrics")
                for int_metric in ["interfaceName", "linkStatus",  "linkStatus", "bufferUnderrunsAvg", "bufferOverrunsAvg", "dropPacketsAvg", "l2DecodeDropsAvg", "inputErrorsAvg", "outputErrorsAvg", "inputBytesAvg", "outputBytesAvg", "inputPacketSizeAvg", "outputPacketSizeAvg"]:
                    new_int_metric.fields[int_metric] = if_data.get(int_metric, "")
                new_int_metric.tags["deviceUid"] =  group["deviceUid"]
                new_int_metric.tags["deviceName"] =  group["deviceName"]
                new_int_metric.tags["interface"] =  if_data["interface"]
                metrics.append(new_int_metric)

    return metrics
