
$base = 'https://api.fiscaldata.treasury.gov/services/api/fiscal_service/v1/accounting/dts'

$rest_url = '/dts_table_2?filter=record_date:gte:{0},transaction_catg:eq:{1}&fields=record_date,transaction_today_amt&page[number]=1&page[size]=300'


# $rest_url = '/dts_table_2?filter=record_date:gte:{0},transaction_catg:eq:{1},transaction_type:eq:Deposits&fields=transaction_type,record_date,transaction_today_amt&page[number]=1&page[size]=300'

# ----------------------------------------------------------------------

# $date = '2022-01-01'

# $date = '2022-05-01'

$date = '2023-01-01'

# $date = '2022-08-01'
# ----------------------------------------------------------------------
# Deposits

$result_pdci_a             = Invoke-RestMethod -Method Get -Uri ($base + '/dts_table_2?filter=record_date:gte:{0},transaction_catg:eq:Public Debt Cash Issues (Table III-B)&page[number]=1&page[size]=300' -f $date) 
$result_pdci_b             = Invoke-RestMethod -Method Get -Uri ($base + '/dts_table_2?filter=record_date:gte:{0},transaction_catg:eq:Public Debt Cash Issues (Table IIIB)&page[number]=1&page[size]=300' -f $date) 

$result_pdci = $result_pdci_a.data + $result_pdci_b.data

$result_sub_total_deposits = Invoke-RestMethod -Method Get -Uri ($base + '/dts_table_2?filter=record_date:gte:{0},transaction_catg:eq:Sub-Total Deposits&page[number]=1&page[size]=300' -f $date) 

# $result_income_taxes             = Invoke-RestMethod -Method Get -Uri ($base + '/dts_table_2?filter=record_date:gte:{0},transaction_catg:gte:Individual Income,transaction_catg:lt:Int&page[number]=1&page[size]=300' -f $date) 
# $result_federal_reserve_earnings = Invoke-RestMethod -Method Get -Uri ($base + '/dts_table_2?filter=record_date:gte:{0},transaction_catg:eq:Federal Reserve Earnings&fields=record_date,transaction_today_amt&page[number]=1&page[size]=300' -f $date) 

# $result_federal_tax_deposits = Invoke-RestMethod -Method Get -Uri ($base + '/dts_table_2?filter=record_date:gte:{0},transaction_catg:eq:{1}&fields=record_date,transaction_today_amt&page[number]=1&page[size]=300' -f $date, "Cash FTD's Received (Table IV)") 

$result_cash_ftds_received_table_iv = Invoke-RestMethod -Method Get -Uri ($base + '/dts_table_2?filter=record_date:gte:{0},transaction_catg:eq:{1}&fields=record_date,transaction_today_amt&page[number]=1&page[size]=300' -f $date, "Cash FTD's Received (Table IV)") 

$result_public_debt_cash_issues_table_iiib = Invoke-RestMethod -Method Get -Uri ($base + $rest_url -f $date, 'Public Debt Cash Issues (Table IIIB)')

# $result_taxes_corporate_income                 = Invoke-RestMethod -Method Get -Uri ($base + $rest_url -f $date, 'Taxes - Corporate Income')
# $result_taxes_non_withheld_ind_seca_other      = Invoke-RestMethod -Method Get -Uri ($base + $rest_url -f $date, 'Taxes - Non Withheld Ind/SECA Other')
# $result_taxes_non_withheld_ind_seca_electronic = Invoke-RestMethod -Method Get -Uri ($base + $rest_url -f $date, 'Taxes - Non Withheld Ind/SECA Electronic')
# $result_taxes_miscellaneous_excise             = Invoke-RestMethod -Method Get -Uri ($base + $rest_url -f $date, 'Taxes - Miscellaneous Excise')
# $result_taxes_withheld_individual_fica         = Invoke-RestMethod -Method Get -Uri ($base + $rest_url -f $date, 'Taxes - Withheld Individual/FICA')

# ----------------------------------------------------------------------
# Withdrawals

$result_pdcr_a             = Invoke-RestMethod -Method Get -Uri ($base + '/dts_table_2?filter=record_date:gte:{0},transaction_catg:eq:Public Debt Cash Redemp. (Table III-B)&page[number]=1&page[size]=300' -f $date) 
$result_pdcr_b             = Invoke-RestMethod -Method Get -Uri ($base + '/dts_table_2?filter=record_date:gte:{0},transaction_catg:eq:Public Debt Cash Redemp. (Table IIIB)&page[number]=1&page[size]=300' -f $date) 

$result_pdcr = $result_pdcr_a.data + $result_pdcr_b.data

# $result_ssa_benefits = Invoke-RestMethod -Method Get -Uri ($base + '/dts_table_2?filter=record_date:gte:{0},transaction_catg:eq:SSA - Benefits Payments&fields=record_date,transaction_today_amt&page[number]=1&page[size]=300' -f $date) 

# $result_hhs_fed_sup = Invoke-RestMethod -Method Get -Uri ($base + '/dts_table_2?filter=record_date:gte:{0},transaction_catg:eq:HHS - Federal Supple Med Insr Trust Fund&fields=record_date,transaction_today_amt&page[number]=1&page[size]=300' -f $date) 
# $result_hhs_fed_hos = Invoke-RestMethod -Method Get -Uri ($base + '/dts_table_2?filter=record_date:gte:{0},transaction_catg:eq:HHS - Federal Hospital Insr Trust Fund&fields=record_date,transaction_today_amt&page[number]=1&page[size]=300' -f $date) 

$result_public_debt_cash_redemp_table_iiib = Invoke-RestMethod -Method Get -Uri ($base + $rest_url -f $date, 'Public Debt Cash Redemp. (Table IIIB)')
# $result_interest_on_treasury_securities     = Invoke-RestMethod -Method Get -Uri ($base + $rest_url -f $date, 'Interest on Treasury Securities') 
# $result_taxes_individual_tax_refunds        = Invoke-RestMethod -Method Get -Uri ($base + $rest_url -f $date, 'Taxes - Individual Tax Refunds (EFT)') 

# $result_defense_vendor_payments             = Invoke-RestMethod -Method Get -Uri ($base + $rest_url -f $date, 'Defense Vendor Payments (EFT)')


# $result_hhs_grants_to_states_for_medicaid = Invoke-RestMethod -Method Get -Uri ($base + $rest_url -f $date, 'HHS - Grants to States for Medicaid')

# ----------------------------------------------------------------------
$deposits = @{}

function register-deposit ($label)
{
    $deposits[$label] = Invoke-RestMethod -Method Get -Uri ($base + $rest_url -f $date, $label)
}

register-deposit 'Taxes - Withheld Individual/FICA'
register-deposit 'Taxes - Corporate Income'
register-deposit 'Taxes - Non Withheld Ind/SECA Other'
register-deposit 'Taxes - Non Withheld Ind/SECA Electronic'
register-deposit 'Taxes - Miscellaneous Excise'

# ----------------------------------------------------------------------

$withdrawals = [ordered]@{}

# $withdrawals['Defense Vendor Payments (EFT)']       = Invoke-RestMethod -Method Get -Uri ($base + $rest_url -f $date, 'Defense Vendor Payments (EFT)')
# $withdrawals['HHS - Grants to States for Medicaid'] = Invoke-RestMethod -Method Get -Uri ($base + $rest_url -f $date, 'HHS - Grants to States for Medicaid')

function register-withdrawal ($label)
{
    $withdrawals[$label] = Invoke-RestMethod -Method Get -Uri ($base + $rest_url -f $date, $label)
}

register-withdrawal 'Interest on Treasury Securities'
register-withdrawal 'Taxes - Individual Tax Refunds (EFT)'
register-withdrawal 'HHS - Federal Supple Med Insr Trust Fund'
register-withdrawal 'HHS - Federal Hospital Insr Trust Fund'
register-withdrawal 'SSA - Benefits Payments'
register-withdrawal 'Defense Vendor Payments (EFT)'
register-withdrawal 'HHS - Grants to States for Medicaid'
register-withdrawal 'Federal Salaries (EFT)'
register-withdrawal 'Other Withdrawals'
register-withdrawal 'Taxes - Business Tax Refunds (EFT)'
register-withdrawal 'Dept of Education (ED)'
register-withdrawal 'USDA - Supp Nutrition Assist Prog (SNAP)'
register-withdrawal 'Dept of Energy (DOE)'
register-withdrawal 'USDA - Child Nutrition'
register-withdrawal 'OPM - Federal Employee Insurance Payment'
register-withdrawal 'Dept of Veterans Affairs (VA)'
register-withdrawal 'HHS - National Institutes of Health'
register-withdrawal 'Postal Service Money Orders and Other'
register-withdrawal 'DOT - Federal Highway Administration'
register-withdrawal 'HHS - Payments to States'
# register-withdrawal 'Dept of Treasury (TREAS) - misc'
register-withdrawal 'DHS - Fed Emergency Mgmt Agency (FEMA)'
# register-withdrawal 'HHS - Othr Admin for Children & Families'
# register-withdrawal 'DHS - Customs & Border Protection (CBP)'
# register-withdrawal 'Federal Communications Commission (FCC)'
# register-withdrawal 'Dept of Housing & Urban Dev (HUD) - misc'
register-withdrawal 'Dept of Justice (DOJ)'
# register-withdrawal 'Dept of Interior (DOI) - misc'
# register-withdrawal 'Dept of Labor (DOL) - misc'

# ----------------------------------------------------------------------



$rest_url_alt = '/dts_table_2?filter=record_date:gte:{0},transaction_catg:eq:{1}&fields=transaction_type,record_date,transaction_today_amt&page[number]=1&page[size]=600'

# $rest_url = '/dts_table_2?filter=record_date:gte:{0},transaction_catg:eq:{1},transaction_type:eq:Deposits&fields=transaction_type,record_date,transaction_today_amt&page[number]=1&page[size]=300'

$result_federal_deposit_insurance_corp_fdic = Invoke-RestMethod -Method Get -Uri ($base + $rest_url_alt -f $date, 'Federal Deposit Insurance Corp (FDIC)')

$result_federal_deposit_insurance_corp_fdic_deposits    = $result_federal_deposit_insurance_corp_fdic.data | Where-Object transaction_type -EQ Deposits
$result_federal_deposit_insurance_corp_fdic_withdrawals = $result_federal_deposit_insurance_corp_fdic.data | Where-Object transaction_type -EQ Withdrawals


$result_sub_total_withdrawals = Invoke-RestMethod -Method Get -Uri ($base + '/dts_table_2?filter=record_date:gte:{0},transaction_catg:eq:Sub-Total Withdrawals&page[number]=1&page[size]=300' -f $date) 

# Change

$result_pdc_change = for ($i = 0; $i -lt $result_pdci.Count; $i++)
{
    [pscustomobject] @{
        record_date = $result_pdci[$i].record_date
        transaction_today_amt = $result_pdci[$i].transaction_today_amt - $result_pdcr[$i].transaction_today_amt
    }
}

$result_sub_total_change = for ($i = 0; $i -lt $result_sub_total_deposits.data.Count; $i++)
{
    [pscustomobject] @{
        record_date = $result_sub_total_deposits.data[$i].record_date
        transaction_today_amt = $result_sub_total_deposits.data[$i].transaction_today_amt - $result_sub_total_withdrawals.data[$i].transaction_today_amt
    }
}

function null_small_amounts ($data, $amt)
{
    foreach ($row in $data)
    {
        if ([math]::Abs([decimal]$row.transaction_today_amt) -lt $amt)
        {
            $row.transaction_today_amt = $null
        }
    }
}

# null_small_amounts $result_pdci 5000
# null_small_amounts $result_pdcr 9000
# null_small_amounts $result_income_taxes.data 1000
# null_small_amounts $result_federal_reserve_earnings.data 1000
# null_small_amounts $result_ssa_benefits.data 600
# null_small_amounts $result_hhs_fed_sup.data 3000
# null_small_amounts $result_hhs_fed_hos.data 3000
# null_small_amounts $result_pdc_change 2000

# ----------------------------------------------------------------------

function negative ($val)
{
    if ($val) { -$val } else { $null }
}

# ----------------------------------------------------------------------

function normalize-data ($obj)
{
    $ls = foreach ($row in $result_sub_total_change)
    {
        [PSCustomObject]@{
            record_date = $row.record_date
            transaction_today_amt = $null
        }
    }
    
    foreach ($row in $obj.data)
    {
        $entry = $ls | Where-Object record_date -EQ $row.record_date | Select-Object -First 1
    
        $entry.transaction_today_amt = $row.transaction_today_amt
    }    

    $ls
}
# ----------------------------------------------------------------------

$colors = @(
    "#4E79A7"
    "#F28E2B"
    "#E15759"
    "#76B7B2"
    "#59A14F"
    "#EDC948"
    "#B07AA1"
    "#FF9DA7"
    "#9C755F"
    "#BAB0AC"
  # "#FFFFFF"
    "#000000"

    # "#c47c5e"
    # "#522426"

    # '#00429d'
    # '#3761ab'
    # '#5681b9'
    # '#73a2c6'
    # '#93c4d2'
    # '#b9e5dd'
    # '#ffffe0'
    # '#ffd3bf'
    # '#ffa59e'
    # '#f4777f'
    # '#dd4c65'
    # '#be214d'
    # '#93003a'

)


$i = 0


$fill = $false


function create-dataset-deposit ($label)
{
    @{ 
        label = 'DEP ' + $label
        
        # data = $withdrawals[$label].data.ForEach({ negative $_.transaction_today_amt })

        data = (normalize-data $deposits[$label]).ForEach({ $_.transaction_today_amt })
                
        spanGaps = $true
        
        lineTension = 0
        
        fill = $fill
        
        backgroundColor = $colors[$Global:i++ % $colors.Count] 
    }
}



function create-dataset-withdrawal ($label)
{
    @{ 
        # label = $label

        label = 'WIT ' + $label
        
        # data = $withdrawals[$label].data.ForEach({ negative $_.transaction_today_amt })

        data = (normalize-data $withdrawals[$label]).ForEach({ negative $_.transaction_today_amt })
                
        spanGaps = $true
        
        lineTension = 0
        
        fill = $fill
        
        backgroundColor = $colors[$Global:i++ % $colors.Count] 
    }
}

# $label = 'HHS - Grants to States for Medicaid'

# $withdrawals[$label]

# @{ label = 'HHS - Grants to States for Medicaid';      data =                 $result_hhs_grants_to_states_for_medicaid.data.ForEach({ negative $_.transaction_today_amt }); spanGaps = $true; lineTension = 0; fill = $fill; backgroundColor = $colors[$Global:i++ % $colors.Count] }


# $withdrawals.Keys | ForEach-Object { create-dataset-withdrawal $_ }

# @(
#     @{ label = 'HHS - Federal Hospital Insr Trust Fund';   data =                 $result_hhs_fed_hos.data.ForEach({                      negative $_.transaction_today_amt }); spanGaps = $true; lineTension = 0; fill = $fill; backgroundColor = $colors[$Global:i++ % $colors.Count] }
#     @{ label = 'Interest on Treasury Securities';          data =                 $result_interest_on_treasury_securities.data.ForEach({  negative $_.transaction_today_amt }); spanGaps = $true; lineTension = 0; fill = $fill; backgroundColor = $colors[$Global:i++ % $colors.Count] }
# ) + 
# ($withdrawals.Keys | ForEach-Object { create-dataset-withdrawal $_ })

# $json = @{
#     chart = @{
#         # type = 'line'
#         type = 'bar'
#         data = @{
#             labels = $result_pdc_change.ForEach({ $_.record_date })
#             datasets = @(

#                 # DEPOSITS

#               # @{ label = 'Public Debt Cash Change';                     data =                 $result_pdc_change.ForEach({                                     $_.transaction_today_amt }); spanGaps = $true; lineTension = 0; fill = $fill }
#                 @{ label = 'Public Debt Cash Issues (Table IIIB)';        data = (normalize-data $result_public_debt_cash_issues_table_iiib).ForEach({            $_.transaction_today_amt }); spanGaps = $true; lineTension = 0; fill = $fill; backgroundColor = $colors[$Global:i++ % $colors.Count]; hidden = $true }                
#               # @{ label = 'Sub-total Change';                            data =                 $result_sub_total_change.ForEach({                               $_.transaction_today_amt }); spanGaps = $true; lineTension = 0; fill = $fill }

#                 @{ label = 'Federal Deposit Insurance Corp (FDIC) [dep]'; data = (               $result_federal_deposit_insurance_corp_fdic_deposits).ForEach({  $_.transaction_today_amt }); spanGaps = $true; lineTension = 0; fill = $fill; backgroundColor = $colors[$Global:i++ % $colors.Count] }
                
#                 @{ label = "Cash FTD's Received (Table IV)";              data = (normalize-data $result_cash_ftds_received_table_iv   ).ForEach({                $_.transaction_today_amt }); spanGaps = $true; lineTension = 0; fill = $fill; backgroundColor = $colors[$Global:i++ % $colors.Count] }
#                 # @{ label = 'Taxes - Withheld Individual/FICA';            data = (normalize-data $result_taxes_withheld_individual_fica).ForEach({                $_.transaction_today_amt }); spanGaps = $true; lineTension = 0; fill = $fill; backgroundColor = $colors[$Global:i++ % $colors.Count] }
#                 @{ label = 'Taxes - Corporate Income';                    data = (normalize-data $result_taxes_corporate_income).ForEach({                        $_.transaction_today_amt }); spanGaps = $true; lineTension = 0; fill = $fill; backgroundColor = $colors[$Global:i++ % $colors.Count] }
#                 @{ label = 'Taxes - Non Withheld Ind/SECA Other';         data = (normalize-data $result_taxes_non_withheld_ind_seca_other).ForEach({             $_.transaction_today_amt }); spanGaps = $true; lineTension = 0; fill = $fill; backgroundColor = $colors[$Global:i++ % $colors.Count] }
#                 @{ label = 'Taxes - Non Withheld Ind/SECA Electronic';    data = (normalize-data $result_taxes_non_withheld_ind_seca_electronic).ForEach({        $_.transaction_today_amt }); spanGaps = $true; lineTension = 0; fill = $fill; backgroundColor = $colors[$Global:i++ % $colors.Count] }
#                 @{ label = 'Taxes - Miscellaneous Excise';                data = (normalize-data $result_taxes_miscellaneous_excise).ForEach({                    $_.transaction_today_amt }); spanGaps = $true; lineTension = 0; fill = $fill; backgroundColor = $colors[$Global:i++ % $colors.Count] }                
                
#                 # WITHDRAWALS

#                 @{ label = 'Public Debt Cash Redemp. (Table IIIB)';    data = (normalize-data $result_public_debt_cash_redemp_table_iiib).ForEach({   negative $_.transaction_today_amt }); spanGaps = $true; lineTension = 0; fill = $fill; backgroundColor = $colors[$Global:i++ % $colors.Count]; hidden = $true }
                
#                 @{ label = 'SSA - Benefits Payments';                  data =                 $result_ssa_benefits.data.ForEach({                     negative $_.transaction_today_amt }); spanGaps = $true; lineTension = 0; fill = $fill; backgroundColor = $colors[$Global:i++ % $colors.Count] }
#                 @{ label = 'HHS - Federal Supple Med Insr Trust Fund'; data =                 $result_hhs_fed_sup.data.ForEach({                      negative $_.transaction_today_amt }); spanGaps = $true; lineTension = 0; fill = $fill; backgroundColor = $colors[$Global:i++ % $colors.Count] }
#                 @{ label = 'HHS - Federal Hospital Insr Trust Fund';   data =                 $result_hhs_fed_hos.data.ForEach({                      negative $_.transaction_today_amt }); spanGaps = $true; lineTension = 0; fill = $fill; backgroundColor = $colors[$Global:i++ % $colors.Count] }
#                 @{ label = 'Interest on Treasury Securities';          data =                 $result_interest_on_treasury_securities.data.ForEach({  negative $_.transaction_today_amt }); spanGaps = $true; lineTension = 0; fill = $fill; backgroundColor = $colors[$Global:i++ % $colors.Count] }
#                 @{ label = 'Taxes - Individual Tax Refunds (EFT)';     data = (normalize-data $result_taxes_individual_tax_refunds).ForEach({         negative $_.transaction_today_amt }); spanGaps = $true; lineTension = 0; fill = $fill; backgroundColor = $colors[$Global:i++ % $colors.Count] }
#                 # @{ label = 'Defense Vendor Payments (EFT)';            data =                 $result_defense_vendor_payments.data.ForEach({          negative $_.transaction_today_amt }); spanGaps = $true; lineTension = 0; fill = $fill; backgroundColor = $colors[$Global:i++ % $colors.Count] }                

#                 # (create-dataset-withdrawal 'Defense Vendor Payments (EFT)')

#                 @{ label = 'Federal Deposit Insurance Corp (FDIC) [wit]';    data = ($result_federal_deposit_insurance_corp_fdic_withdrawals).ForEach({  negative $_.transaction_today_amt }); spanGaps = $true; lineTension = 0; fill = $fill; backgroundColor = $colors[$Global:i++ % $colors.Count] }

#                 # @{ label = 'HHS - Grants to States for Medicaid';      data =                 $result_hhs_grants_to_states_for_medicaid.data.ForEach({ negative $_.transaction_today_amt }); spanGaps = $true; lineTension = 0; fill = $fill; backgroundColor = $colors[$Global:i++ % $colors.Count] }


#                 # (create-dataset-withdrawal 'HHS - Grants to States for Medicaid')



#                 # $result_hhs_grants_to_states_for_medicaid = Invoke-RestMethod -Method Get -Uri ($base + $rest_url -f $date, 'HHS - Grants to States for Medicaid')


#                 # $result_federal_deposit_insurance_corp_fdic = Invoke-RestMethod -Method Get -Uri ($base + $rest_url -f $date, 'Federal Deposit Insurance Corp (FDIC)')
                
#             ) + ($withdrawals.Keys | ForEach-Object { create-dataset-withdrawal $_ })
#         }
#         options = @{
#             title = @{ display = $true; text = 'Treasury General Account' }
#             legend = @{ position = 'left' }
#             scales = @{ 
#                 xAxes = @(@{ stacked = $true }) 
#                 yAxes = @(@{ stacked = $true }) 
#             }
#         }
#     }
# } | ConvertTo-Json -Depth 100



$json = @{
    chart = @{
        # type = 'line'
        type = 'bar'
        data = @{
            labels = $result_pdc_change.ForEach({ $_.record_date })
            datasets = @(

                # DEPOSITS

              # @{ label = 'Public Debt Cash Change';                     data =                 $result_pdc_change.ForEach({                                     $_.transaction_today_amt }); spanGaps = $true; lineTension = 0; fill = $fill }
                @{ label = 'Public Debt Cash Issues (Table IIIB)';        data = (normalize-data $result_public_debt_cash_issues_table_iiib).ForEach({            $_.transaction_today_amt }); spanGaps = $true; lineTension = 0; fill = $fill; backgroundColor = $colors[$Global:i++ % $colors.Count]; hidden = $true }                
              # @{ label = 'Sub-total Change';                            data =                 $result_sub_total_change.ForEach({                               $_.transaction_today_amt }); spanGaps = $true; lineTension = 0; fill = $fill }

                @{ label = 'Federal Deposit Insurance Corp (FDIC) [dep]'; data = (               $result_federal_deposit_insurance_corp_fdic_deposits).ForEach({  $_.transaction_today_amt }); spanGaps = $true; lineTension = 0; fill = $fill; backgroundColor = $colors[$Global:i++ % $colors.Count] }
                
                @{ label = "Cash FTD's Received (Table IV)";              data = (normalize-data $result_cash_ftds_received_table_iv   ).ForEach({                $_.transaction_today_amt }); spanGaps = $true; lineTension = 0; fill = $fill; backgroundColor = $colors[$Global:i++ % $colors.Count] }
                # @{ label = 'Taxes - Withheld Individual/FICA';            data = (normalize-data $result_taxes_withheld_individual_fica).ForEach({                $_.transaction_today_amt }); spanGaps = $true; lineTension = 0; fill = $fill; backgroundColor = $colors[$Global:i++ % $colors.Count] }
                # @{ label = 'Taxes - Corporate Income';                    data = (normalize-data $result_taxes_corporate_income).ForEach({                        $_.transaction_today_amt }); spanGaps = $true; lineTension = 0; fill = $fill; backgroundColor = $colors[$Global:i++ % $colors.Count] }
                # @{ label = 'Taxes - Non Withheld Ind/SECA Other';         data = (normalize-data $result_taxes_non_withheld_ind_seca_other).ForEach({             $_.transaction_today_amt }); spanGaps = $true; lineTension = 0; fill = $fill; backgroundColor = $colors[$Global:i++ % $colors.Count] }
                # @{ label = 'Taxes - Non Withheld Ind/SECA Electronic';    data = (normalize-data $result_taxes_non_withheld_ind_seca_electronic).ForEach({        $_.transaction_today_amt }); spanGaps = $true; lineTension = 0; fill = $fill; backgroundColor = $colors[$Global:i++ % $colors.Count] }
                # @{ label = 'Taxes - Miscellaneous Excise';                data = (normalize-data $result_taxes_miscellaneous_excise).ForEach({                    $_.transaction_today_amt }); spanGaps = $true; lineTension = 0; fill = $fill; backgroundColor = $colors[$Global:i++ % $colors.Count] }                
            ) + 
            ($deposits.Keys | ForEach-Object { create-dataset-deposit $_ }) +
            @(
                
                # WITHDRAWALS

                @{ label = 'Public Debt Cash Redemp. (Table IIIB)';    data = (normalize-data $result_public_debt_cash_redemp_table_iiib).ForEach({   negative $_.transaction_today_amt }); spanGaps = $true; lineTension = 0; fill = $fill; backgroundColor = $colors[$Global:i++ % $colors.Count]; hidden = $true }
                
                # @{ label = 'SSA - Benefits Payments';                  data =                 $result_ssa_benefits.data.ForEach({                     negative $_.transaction_today_amt }); spanGaps = $true; lineTension = 0; fill = $fill; backgroundColor = $colors[$Global:i++ % $colors.Count] }
                # @{ label = 'HHS - Federal Supple Med Insr Trust Fund'; data =                 $result_hhs_fed_sup.data.ForEach({                      negative $_.transaction_today_amt }); spanGaps = $true; lineTension = 0; fill = $fill; backgroundColor = $colors[$Global:i++ % $colors.Count] }
                # @{ label = 'HHS - Federal Hospital Insr Trust Fund';   data =                 $result_hhs_fed_hos.data.ForEach({                      negative $_.transaction_today_amt }); spanGaps = $true; lineTension = 0; fill = $fill; backgroundColor = $colors[$Global:i++ % $colors.Count] }
                # @{ label = 'Interest on Treasury Securities';          data =                 $result_interest_on_treasury_securities.data.ForEach({  negative $_.transaction_today_amt }); spanGaps = $true; lineTension = 0; fill = $fill; backgroundColor = $colors[$Global:i++ % $colors.Count] }
                # @{ label = 'Taxes - Individual Tax Refunds (EFT)';     data = (normalize-data $result_taxes_individual_tax_refunds).ForEach({         negative $_.transaction_today_amt }); spanGaps = $true; lineTension = 0; fill = $fill; backgroundColor = $colors[$Global:i++ % $colors.Count] }
                # @{ label = 'Defense Vendor Payments (EFT)';            data =                 $result_defense_vendor_payments.data.ForEach({          negative $_.transaction_today_amt }); spanGaps = $true; lineTension = 0; fill = $fill; backgroundColor = $colors[$Global:i++ % $colors.Count] }                

                # (create-dataset-withdrawal 'Defense Vendor Payments (EFT)')

                @{ label = 'Federal Deposit Insurance Corp (FDIC) [wit]';    data = ($result_federal_deposit_insurance_corp_fdic_withdrawals).ForEach({  negative $_.transaction_today_amt }); spanGaps = $true; lineTension = 0; fill = $fill; backgroundColor = $colors[$Global:i++ % $colors.Count] }

                # @{ label = 'HHS - Grants to States for Medicaid';      data =                 $result_hhs_grants_to_states_for_medicaid.data.ForEach({ negative $_.transaction_today_amt }); spanGaps = $true; lineTension = 0; fill = $fill; backgroundColor = $colors[$Global:i++ % $colors.Count] }


                # (create-dataset-withdrawal 'HHS - Grants to States for Medicaid')



                # $result_hhs_grants_to_states_for_medicaid = Invoke-RestMethod -Method Get -Uri ($base + $rest_url -f $date, 'HHS - Grants to States for Medicaid')


                # $result_federal_deposit_insurance_corp_fdic = Invoke-RestMethod -Method Get -Uri ($base + $rest_url -f $date, 'Federal Deposit Insurance Corp (FDIC)')
                
            ) + ($withdrawals.Keys | ForEach-Object { create-dataset-withdrawal $_ })
        }
        options = @{
            title = @{ display = $true; text = 'Treasury General Account' }
            legend = @{ position = 'left' }
            scales = @{ 
                xAxes = @(@{ stacked = $true }) 
                yAxes = @(@{ stacked = $true }) 
            }
        }
    }
} | ConvertTo-Json -Depth 100







$result = Invoke-RestMethod -Method Post -Uri 'https://quickchart.io/chart/create' -Body $json -ContentType 'application/json'

# Start-Process $result.url

$id = ([System.Uri] $result.url).Segments[-1]

Start-Process ('https://quickchart.io/chart-maker/view/{0}' -f $id)

# ----------------------------------------------------------------------