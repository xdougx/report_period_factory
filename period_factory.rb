# Modulo para a geração de filtros de tempo em uma classe Active Record
module ReportModules::PeriodFactory
  extend ActiveSupport::Concern
  
  module ClassMethods
    def build_perid method, params = {}
      method = :current_week if method.nil?
      case method.to_sym
      when :period then period(params)
      when :daily then current_day(params[:date_attr])
      when :current_week then current_week(params[:date_attr])
      when :current_month then current_month(params[:date_attr])
      when :current_quarter then current_quarter(params[:date_attr])
      when :current_half then current_half(params[:date_attr])
      when :current_year then current_year(params[:date_attr])
      when :years_before then current_year(params[:years])
      else current_week(params[:date_attr])
      end
    end

    # periodo desejado
    def period params
      start_date = parse_date(params[:start_date], beginning_of_day: true)
      end_date = parse_date(params[:end_date], end_of_day: true)
      period = start_date..end_date
      self.where(created_at: period)
    end

    # dia atual
    def current_day attr_sym
      start_date = Time.now.beginning_of_day
      end_date = Time.now.end_of_day
      period = start_date..end_date
      self.where(attr_sym => period)
    end
    # semana atual
    def current_week attr_sym
      attr_sym = 'created_at' if attr_sym.nil?
      self.where(attr_sym => Time.now.all_week)
    end
    # mes atual
    def current_month attr_sym
      attr_sym = 'created_at' if attr_sym.nil?
      self.where(attr_sym => Time.now.all_month)
    end

    # bimestre atual
    def current_quarter attr_sym
      attr_sym = 'created_at' if attr_sym.nil?
      self.where(attr_sym => Time.now.all_quarter)

      end_date = Time.now.end_of_month
      start_date = end_date - 3.months
      period = start_date..end_date
      self.where(attr_sym => period)
    end

    # semestre atual
    def current_half attr_sym
      attr_sym = 'created_at' if attr_sym.nil?
      end_date = Time.now.end_of_month
      start_date = end_date - 6.months
      period = start_date..end_date
      self.where(attr_sym => period)
    end

    # ano atual
    def current_year attr_sym
      attr_sym = 'created_at' if attr_sym.nil?
      end_date = Time.now
      start_date = end_date - 1.year
      period = start_date..end_date
      self.where(attr_sym => period)
    end

    # anos atrás
    def years_before years, attr_sym
      attr_sym = 'created_at' if attr_sym.nil?
      start_date = year.years.ago.at_beginning_of_year
      start_end = year.years.ago.at_end_of_year
      period = start_date..end_date
      self.where(attr_sym => period)
    end

    # transforma uma data em current, inicio do dia ou final do dia
    def parse_date date, options = {}
      date = Time.parse(date)
      date = date.beginning_of_day if options[:beginning_of_day]
      date = date.end_of_day if options[:end_of_day]
      date
    end

    # gera a mascara para o banco de dados
    def build_date_format params
      case params[:period_method]
      when "daily" then "DD Mon YYYY"
      when "weekly" then "DD Mon YYYY"
      when "monthly" then "DD Mon YYYY"
      when "quarter" then "Mon YYYY"
      when "half" then "Mon YYYY"
      when "yearly" then "Mon YYYY"
      when "current_week" then "DD Mon YYYY"
      when "current_month" then "DD Mon YYYY"
      when "current_quarter" then "Mon YYYY"
      when "current_half" then "Mon YYYY"
      when "current_year" then "Mon YYYY"
      end
    end

    # formata a data para o front-end
    def format_date date, period_method
      date = Date.parse(date)
      case period_method
      when "daily" then I18n.l(date, format: "%d %b %Y")
      when "weekly" then I18n.l(date, format: "%d %b %Y")
      when "monthly" then I18n.l(date, format: "%d %b %Y")
      when "quarter" then I18n.l(date, format: "%b %Y")
      when "half" then I18n.l(date, format: "%b %Y")
      when "yearly" then I18n.l(date, format: "%b %Y")
      when "current_week" then I18n.l(date, format: "%d %b %Y")
      when "current_month" then I18n.l(date, format: "%d %b %Y")
      when "current_quarter" then I18n.l(date, format: "%b %Y")
      when "current_half" then I18n.l(date, format: "%b %Y")
      when "current_year" then I18n.l(date, format: "%b %Y")
      end
    end
  end
end
