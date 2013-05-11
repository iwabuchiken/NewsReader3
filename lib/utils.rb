def get_time_label_now()
  
  return Time.now.strftime("%Y/%m/%d %H:%M:%S")
  # return Time.now.strftime("%Y%m%d_%H%M%S")
  
end#def get_time_label_now()


def write_log(text, file, line)
  
  f = open("log.log", "a")
  
  f.write("[begin]------------------------=\n")
  
  # f.write("[#{get_time_label_now()}]" + line + ": " + text)
  f.write("[#{get_time_label_now()}] [#{file}: #{line}] #{text}")
  
  f.write("\n")
  
  f.write("------------------------=[end]\n\n")
  
  f.close
  
end#def write_log()
