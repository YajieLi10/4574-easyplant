select 
    j.employee_id,
    j.name,
    j.city,
    j.address,
    j.title,
    j.annual_salary,
    j.hire_date,
    q.quit_date,
    datediff(day,hire_date,quit_date) as EMPLOYMENT_DURATION
from {{ ref('BASE_GOOGLE_DRIVE__HR_JOINS') }} as j
left join {{ ref('BASE_GOOGLE_DRIVE__HR_QUIST') }} as q
on j.employee_id = q.employee_id



