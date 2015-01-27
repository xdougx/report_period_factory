# Report Period Factory
Ruby on Rails Concern Module para a criação de filtros por periodos

## Como utilizar
coloque esse modulo dentro de um dos concerns, (mais para frente crio uma gem para isso, mas no momento vou apenas disponibilizar o código fonte para poderem usar de forma prática e simples). Renomeie a classe quiser.

### Parametros
#### method
pode ser:
- period
- daily
- current_week
- current_month
- current_quarter
- current_half
- current_year
- years_before

#### years
caso coloque o method `:years_before`, years será a quantidades de anos atás

#### date_attr
escolha o atributo do tipo date para fazer o filtro



```
class Company < ActiveRecord::Base
  #...
end
```

```
class CompanyReport < Company
  include ReportModules::PeriodFactory
  
  def self.average_sales params
    select("sum(sales.total) as total, ...")
      .joins(:sales)
        .where(company_id: 1)
          .build_period(:current_month, date_attr: 'date_in', period_method: 'daily')
  end
end
```
