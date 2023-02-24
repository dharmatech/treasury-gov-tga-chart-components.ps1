$base = 'https://api.fiscaldata.treasury.gov/services/api/fiscal_service/v1/accounting/dts'

$rest_url = '/dts_table_2?filter=record_date:gte:{0},transaction_catg:eq:{1}&fields=record_date,transaction_today_amt&page[number]=1&page[size]=300'

# ----------------------------------------------------------------------

# $date = '2022-04-01'

# $date = '2022-09-01'

# $date = '2022-12-15'
# $date = '2022-12-16'
# $date = '2022-12-19'

# $result_raw = Invoke-RestMethod -Method Get -Uri ($base + '/dts_table_2?filter=record_date:eq:{0}&page[number]=1&page[size]=300' -f $date)
# 
# foreach ($row in $result_raw.data)
# {
#     $row.transaction_fytd_amt  = [decimal]$row.transaction_fytd_amt
#     $row.transaction_today_amt = [decimal]$row.transaction_today_amt
# }
# 
# $result_raw.data | ft *
# 
# $result_raw.data | Where-Object transaction_type -EQ Deposits    | Sort-Object transaction_today_amt -Descending | ft *
# $result_raw.data | Where-Object transaction_type -EQ Withdrawals | Sort-Object transaction_today_amt -Descending | ft *
# 
# $result_raw.data | Where-Object transaction_type -EQ Deposits    | Sort-Object transaction_fytd_amt -Descending | ft *
# $result_raw.data | Where-Object transaction_type -EQ Withdrawals | Sort-Object transaction_fytd_amt -Descending | ft *
# 
# $result_raw.data | Where-Object transaction_type -EQ Deposits    | Sort-Object transaction_today_amt -Descending | Select-Object -First 10 | ft *
# $result_raw.data | Where-Object transaction_type -EQ Withdrawals | Sort-Object transaction_today_amt -Descending | Select-Object -First 10 | ft *
# 
# $result_raw.data | Where-Object transaction_type -EQ Deposits    | Sort-Object transaction_fytd_amt -Descending | Select-Object -First 10 | ft *
# $result_raw.data | Where-Object transaction_type -EQ Withdrawals | Sort-Object transaction_fytd_amt -Descending | Select-Object -First 10 | ft *

# ----------------------------------------------------------------------

# $date = '2022-01-01'

$date = '2022-05-01'

# $date = '2022-08-01'

# Deposits

$result_pdci_a             = Invoke-RestMethod -Method Get -Uri ($base + '/dts_table_2?filter=record_date:gte:{0},transaction_catg:eq:Public Debt Cash Issues (Table III-B)&page[number]=1&page[size]=300' -f $date) 
$result_pdci_b             = Invoke-RestMethod -Method Get -Uri ($base + '/dts_table_2?filter=record_date:gte:{0},transaction_catg:eq:Public Debt Cash Issues (Table IIIB)&page[number]=1&page[size]=300' -f $date) 

$result_pdci = $result_pdci_a.data + $result_pdci_b.data

$result_sub_total_deposits = Invoke-RestMethod -Method Get -Uri ($base + '/dts_table_2?filter=record_date:gte:{0},transaction_catg:eq:Sub-Total Deposits&page[number]=1&page[size]=300' -f $date) 

$result_income_taxes             = Invoke-RestMethod -Method Get -Uri ($base + '/dts_table_2?filter=record_date:gte:{0},transaction_catg:gte:Individual Income,transaction_catg:lt:Int&page[number]=1&page[size]=300' -f $date) 
$result_federal_reserve_earnings = Invoke-RestMethod -Method Get -Uri ($base + '/dts_table_2?filter=record_date:gte:{0},transaction_catg:eq:Federal Reserve Earnings&fields=record_date,transaction_today_amt&page[number]=1&page[size]=300' -f $date) 

# $result_federal_tax_deposits = Invoke-RestMethod -Method Get -Uri ($base + '/dts_table_2?filter=record_date:gte:{0},transaction_catg:eq:{1}&fields=record_date,transaction_today_amt&page[number]=1&page[size]=300' -f $date, "Cash FTD's Received (Table IV)") 

$result_cash_ftds_received_table_iv = Invoke-RestMethod -Method Get -Uri ($base + '/dts_table_2?filter=record_date:gte:{0},transaction_catg:eq:{1}&fields=record_date,transaction_today_amt&page[number]=1&page[size]=300' -f $date, "Cash FTD's Received (Table IV)") 

# Withdrawals

$result_pdcr_a             = Invoke-RestMethod -Method Get -Uri ($base + '/dts_table_2?filter=record_date:gte:{0},transaction_catg:eq:Public Debt Cash Redemp. (Table III-B)&page[number]=1&page[size]=300' -f $date) 
$result_pdcr_b             = Invoke-RestMethod -Method Get -Uri ($base + '/dts_table_2?filter=record_date:gte:{0},transaction_catg:eq:Public Debt Cash Redemp. (Table IIIB)&page[number]=1&page[size]=300' -f $date) 

$result_pdcr = $result_pdcr_a.data + $result_pdcr_b.data

$result_ssa_benefits = Invoke-RestMethod -Method Get -Uri ($base + '/dts_table_2?filter=record_date:gte:{0},transaction_catg:eq:SSA - Benefits Payments&fields=record_date,transaction_today_amt&page[number]=1&page[size]=300' -f $date) 

$result_hhs_fed_sup = Invoke-RestMethod -Method Get -Uri ($base + '/dts_table_2?filter=record_date:gte:{0},transaction_catg:eq:HHS - Federal Supple Med Insr Trust Fund&fields=record_date,transaction_today_amt&page[number]=1&page[size]=300' -f $date) 
$result_hhs_fed_hos = Invoke-RestMethod -Method Get -Uri ($base + '/dts_table_2?filter=record_date:gte:{0},transaction_catg:eq:HHS - Federal Hospital Insr Trust Fund&fields=record_date,transaction_today_amt&page[number]=1&page[size]=300' -f $date) 


$result_interest_on_treasury_securities = Invoke-RestMethod -Method Get -Uri ($base + $rest_url -f $date, 'Interest on Treasury Securities') 
$result_taxes_individual_tax_refunds    = Invoke-RestMethod -Method Get -Uri ($base + $rest_url -f $date, 'Taxes - Individual Tax Refunds (EFT)') 
$result_taxes_withheld_individual_fica  = Invoke-RestMethod -Method Get -Uri ($base + $rest_url -f $date, 'Taxes - Withheld Individual/FICA')




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

# Normalize 'Taxes - Individual Tax Refunds (EFT)'

$result_taxes_individual_tax_refunds_ = foreach ($row in $result_sub_total_change)
{
    [PSCustomObject]@{
        record_date = $row.record_date
        transaction_today_amt = $null
    }
}

foreach ($row in $result_taxes_individual_tax_refunds.data)
{
    $entry = $result_taxes_individual_tax_refunds_ | Where-Object record_date -EQ $row.record_date | Select-Object -First 1

    $entry.transaction_today_amt = $row.transaction_today_amt
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

# $result_federal_tax_deposits_ = normalize-data $result_federal_tax_deposits




# ----------------------------------------------------------------------

$json = @{
    chart = @{
        type = 'line'
        # type = 'bar'
        data = @{
            labels = $result_pdc_change.ForEach({ $_.record_date })
            datasets = @(
                @{ label = 'Public Debt Cash Change';                  data = $result_pdc_change.ForEach({                                     $_.transaction_today_amt }); spanGaps = $true; lineTension = 0; fill = $false }
                @{ label = 'Sub-total Change';                         data = $result_sub_total_change.ForEach({                               $_.transaction_today_amt }); spanGaps = $true; lineTension = 0; fill = $false }
                # @{ label = 'Federal Tax Deposits';                     data = $result_federal_tax_deposits.data.ForEach({                      $_.transaction_today_amt }); spanGaps = $true; lineTension = 0; fill = $false }
                # @{ label = 'Federal Tax Deposits';                     data = $result_federal_tax_deposits_.ForEach({                      $_.transaction_today_amt }); spanGaps = $true; lineTension = 0; fill = $false }

                @{ label = "Cash FTD's Received (Table IV)";       data = (normalize-data $result_cash_ftds_received_table_iv   ).ForEach({ $_.transaction_today_amt }); spanGaps = $true; lineTension = 0; fill = $false }
                @{ label = 'Taxes - Withheld Individual/FICA';     data = (normalize-data $result_taxes_withheld_individual_fica).ForEach({ $_.transaction_today_amt }); spanGaps = $true; lineTension = 0; fill = $false }

                @{ label = 'SSA - Benefits Payments';                  data = $result_ssa_benefits.data.ForEach({                     negative $_.transaction_today_amt }); spanGaps = $true; lineTension = 0; fill = $false }                
                @{ label = 'HHS - Federal Supple Med Insr Trust Fund'; data = $result_hhs_fed_sup.data.ForEach({                      negative $_.transaction_today_amt }); spanGaps = $true; lineTension = 0; fill = $false }                
                @{ label = 'HHS - Federal Hospital Insr Trust Fund';   data = $result_hhs_fed_hos.data.ForEach({                      negative $_.transaction_today_amt }); spanGaps = $true; lineTension = 0; fill = $false }                
                @{ label = 'Interest on Treasury Securities';          data = $result_interest_on_treasury_securities.data.ForEach({  negative $_.transaction_today_amt }); spanGaps = $true; lineTension = 0; fill = $false }                                
                @{ label = 'Taxes - Individual Tax Refunds (EFT)';     data = $result_taxes_individual_tax_refunds_.ForEach({         negative $_.transaction_today_amt }); spanGaps = $true; lineTension = 0; fill = $false }                                

                
            )
        }
        options = @{
            # title = @{ display = $true; text = 'Issues' }
            scales = @{ }
        }
    }
} | ConvertTo-Json -Depth 100

$result = Invoke-RestMethod -Method Post -Uri 'https://quickchart.io/chart/create' -Body $json -ContentType 'application/json'

# Start-Process $result.url

$id = ([System.Uri] $result.url).Segments[-1]

Start-Process ('https://quickchart.io/chart-maker/view/{0}' -f $id)

# ----------------------------------------------------------------------