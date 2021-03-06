SELECT id, primary_email, name,
"eindkomst",
"lønsum",
"selvangivelse_selskaber",
"udbytte",
"selvangivelse_personlig",
"skattekonto",
"moms",
crm.already_given_customer_authorizations("eindkomst","lønsum","selvangivelse_selskaber","udbytte","selvangivelse_personlig","skattekonto","moms") @> crm.customer_authorization(get_extra_packages_previous_year_array(id), get_extra_packages_current_year_array(id), get_service_package_previous_year(id), get_service_package_current_year(id), company_type, has_employees, vat_type) AS all_authorizations_given,
crm.customer_authorization(get_extra_packages_previous_year_array(id), get_extra_packages_current_year_array(id), get_service_package_previous_year(id), get_service_package_current_year(id), company_type, has_employees, vat_type) AS all_required_customer_authorizations,
crm.already_given_customer_authorizations("eindkomst","lønsum","selvangivelse_selskaber","udbytte","selvangivelse_personlig","skattekonto","moms"),
(SELECT ARRAY(SELECT unnest(crm.customer_authorization(get_extra_packages_previous_year_array(id), get_extra_packages_current_year_array(id), get_service_package_previous_year(id), get_service_package_current_year(id), company_type, has_employees, vat_type)) EXCEPT SELECT unnest(crm.already_given_customer_authorizations("eindkomst","lønsum","selvangivelse_selskaber","udbytte","selvangivelse_personlig","skattekonto","moms")))) AS missing_authorizations
from customers
where potential_customer is true
order by id
