class PageContainer
  
  def initialize(browser)
    #$config = load_config() #loads yml config file, see spec_helper for details
    @browser = browser
  end

  def close
    @browser.close 
  end

  def wait_status(element,status)
    i = 1
    count = 30
    interval = 10

    while !(element.text.start_with?(status) or i>count)
      sleep interval
      i = i+1
      @browser.refresh
      puts element.text
    end
  end

  def wait_exist(element)
    i = 1
    count = 10
    interval = 1

    while !(element.exist? or i>count)
      sleep interval
      i = i+1
    end
  end

  def wait_not_exist(element)
    i = 1
    count = 10
    interval = 1

    while (element.exist? and i<count)
      sleep interval
      i = i+1
    end
  end

  def wait_present(element)
    i = 1
    count = 20
    interval = 1

    while !(element.present? or i>count)
      sleep interval
      i = i+1
    end
  end

  def wait_not_present(element)
    i = 1
    count = 10
    interval = 1

    while (element.present? and i<count)
      sleep interval
      i = i+1
    end
  end

  def wait_blank(element)
    i = 1
    count = 10
    interval = 1

    while !(element.blank? or i>count)
      sleep interval
      i = i+1
    end
  end

  def wait_not_blank(element)
    i = 1
    count = 10
    interval = 1

    while (element.blank? and i<count)
      sleep interval
      i = i+1
    end
  end

  def wait_empty(element)
    i = 1
    count = 10
    interval = 1

    while !(element.empty? or i>count)
      sleep interval
      i = i+1
    end
  end

  def wait_not_empty(element)
    i = 1
    count = 10
    interval = 1

    while (element.empty? and i<count)
      sleep interval
      i = i+1
    end
  end

  def wait_enabled(element)
    i = 1
    count = 10
    interval = 1

    while !(element.enabled? or i>count)
      sleep interval
      i = i+1
    end
  end

  def wait_not_enabled(element)
    i = 1
    count = 10
    interval = 1

    while (element.enabled? and i<count)
      sleep interval
      i = i+1
    end
  end

  def wait_equal(element,value)
    i = 1
    count = 10
    interval = 1

    while !(element.eql? value or i>count)
      sleep interval
      i = i+1
    end
  end

  def wait_not_equal(element,value)
    i = 1
    count = 10
    interval = 1

    while (element.eql? value and i<count)
      sleep interval
      i = i+1
    end
  end

end