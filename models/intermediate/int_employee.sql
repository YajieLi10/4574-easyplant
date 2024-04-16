select 
    jj.employee_id,
    jj.name,
    jj.city,
    jj.address,
    jj.title,
    jj.annual_salary,
    jj.hire_date,
    qq.quit_date
from {{ ref('base_google_drive__hr_joins') }} as jj
left join {{ ref('base_google_drive__hr_quist') }} as qq
on jj.employee_id = qq.employee_id