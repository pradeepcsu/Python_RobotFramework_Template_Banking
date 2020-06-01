*** Settings ***
Library           Selenium2Library
Library           Screenshot
Library           MyBranch
Library           Host
Resource          ../../mybranch_keywords.robot

*** Test Cases ***
Account Details - CD
    [Documentation]    UFT test case: 'Account Details - CD'
    [Tags]    qa_suite    uat2_suite    account_details
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}
    View Account Details    ${account_namenumber}

    Open TSSO

    Go To Account Screen    ${account}    stia
    Verify Currency In Host    AccountDetails_CD_DividendsPaidLastPeriod    stia_IntPaymentHistory
    Verify Currency In Host    AccountDetails_CD_DividendsPaidCurrentYear    stia_CurYtd_InterestPaid
    Verify Currency In Host    AccountDetails_CD_DividendsPaidPriorYear    stia_PrevYr_InterestPaid

    Go To Account Screen    ${account_number}    sti1
    Verify Date In Host    AccountDetails_CD_MaturityDate    sti1_NxtMatDt    host_fmt=%m/%d/%Y
    Verify Currency In Host    AccountDetails_CD_CurrentBalance    sti1_CurrentBal
    Verify Currency In Host    AccountDetails_CD_AmountOnHold    sti1_Holds
    Verify Currency In Host    AccountDetails_CD_AvailableBalance    sti1_CollBal

    Host Next Page
    Verify Rate In Host    AccountDetails_CD_DividendRate    sti1_AccrRate
    Verify Date In Host    AccountDetails_CD_OpeningLastRenewalDate    sti1_RenewDate    host_fmt=%m/%d/%Y

    Go To Account Screen    ${account_number}    sti2
    Verify Account CD Transactions Against Host

    [Teardown]    Log Out myBranch

Account Details - CD IRA
    [Documentation]    UFT test case: 'Account Details - CD IRA'
    [Tags]    qa_suite    uat2_suite    account_details
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}
    View Account Details    ${account_namenumber}


    Open TSSO

    Go To Account Screen    ${account}    stia
    Verify Currency In Host    AccountDetails_CDIRA_DividendsPaidLastPeriod    stia_IntPaymentHistory
    Verify Currency In Host    AccountDetails_CDIRA_YearToDateDividendsPaid    stia_CurYtd_InterestPaid
    Verify Currency In Host    AccountDetails_CDIRA_DividendsPaidPriorYear    stia_PrevYr_InterestPaid

    Go To Account Screen    ${account_number}    sti1
    Verify Date In Host    AccountDetails_CDIRA_MaturityDate    sti1_NxtMatDt    host_fmt=%m/%d/%Y
    Verify Currency In Host    AccountDetails_CDIRA_CurrentBalance    sti1_CurrentBal
    Verify Currency In Host    AccountDetails_CDIRA_AmountOnHold    sti1_Holds
    Verify Currency In Host    AccountDetails_CDIRA_AvailableBalance    sti1_CollBal

    Host Next Page
    Verify Rate In Host    AccountDetails_CDIRA_DividendRate    sti1_AccrRate
    Verify Date In Host    AccountDetails_CDIRA_OpeningLastRenewalDate    sti1_RenewDate    host_fmt=%m/%d/%Y

    Go To Account Screen    ${account_number}    sti2
    Verify Account CD Transactions Against Host

    [Teardown]    Log Out myBranch

Account Details - Savings
    [Documentation]    UFT test case: 'Account Details - Savings'
    [Tags]    qa_suite    uat2_suite    account_details
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}
    View Account Details    ${account_namenumber}

    Open TSSO

    Go To Account Screen    ${account_number}    imi1
    Verify Currency In Host    AccountDetails_IM_CurrentBalance    imi1_LedgerBal
    Verify Currency In Host    AccountDetails_IM_AmountOnHold    imi1_TotalHolds
    Verify Currency In Host    AccountDetails_IM_AvailableBalance    imi1_MemoBalance

    Host Next Page
    Verify Currency In Host    AccountDetails_IM_DividendsPaidCurrentYear    imi1_YTD_IOD
    Verify Currency In Host    AccountDetails_IM_DividendsPaidPriorYear    imi1_Prev_IOD

    Go To Account Screen    ${account_number}    imi2
    Verify Account Savings Transactions Against Host

    [Teardown]    Log Out myBranch
    
Account Details - Checking
    [Documentation]    UFT test case: 'Account Details - Checking'
    [Tags]    qa_suite    uat2_suite    account_details
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}
    View Account Details    ${account_namenumber}

    Open TSSO

    Go To Account Screen    ${account_number}    imi1
    Verify Currency In Host    AccountDetails_IM_CurrentBalance    imi1_LedgerBal
    Verify Currency In Host    AccountDetails_IM_AmountOnHold    imi1_TotalHolds
    Verify Currency In Host    AccountDetails_IM_AvailableBalance    imi1_MemoBalance

    Host Next Page
    Verify Currency In Host    AccountDetails_IM_DividendsPaidCurrentYear    imi1_YTD_IOD
    Verify Currency In Host    AccountDetails_IM_DividendsPaidPriorYear    imi1_Prev_IOD

    Go To Account Screen    ${account_number}    imi2
    Verify Account Checking Transactions Against Host

    [Teardown]    Log Out myBranch

Account Details - Loan
    [Documentation]    UFT test case: 'Account Details - Loan'
    [Tags]    qa_suite    uat2_suite    account_details
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}
    View Account Details    ${account_namenumber}

    Open TSSO

    Go To Account Screen    ${account_number}    amai
    Verify Currency In Host    AccountDetails_Loan_DailyInterestAmount    amai_PerDiem
    ${result} =    Run Keyword And Return Status    Verify Currency In Host    AccountDetails_Loan_NextPaymentAmount    amai_CurPymtAmt
    Run Keyword If    '${result}' == 'False'    Verify Currency In Host    AccountDetails_Loan_NextPaymentAmount    amai_SchPymtAmt
    Verify Date In Host    AccountDetails_Loan_NextPaymentDate    amai_OldestDueDate
    Verify Currency In Host    AccountDetails_Loan_PrincipalBalance    amai_CurrentPrin
    Verify Currency In Host    AccountDetails_Loan_PayoffAmount    amai_Payoff

    Go To Account Screen    ${account_number}    amn1
    Verify Rate In Host    AccountDetails_Loan_InterestRate    amn1_apr
    Verify Date In Host    AccountDetails_Loan_MaturityDate    amn1_maturity_date

    Go To Account Screen    ${account_number}    amn3
    Verify Currency In Host    AccountDetails_Loan_CurrentYearInterestPaid    amn3_YtdInterest
    Verify Currency In Host    AccountDetails_Loan_PriorYearInterestPaid    amn3_PrevYrInt

    Go To Account Screen    ${account_number}    amn9
    Verify Currency In Host    AccountDetails_Loan_LastPaymentAmount    amn9_LastPmtAmt
    Verify Date In Host    AccountDetails_Loan_LastPaymentDate    amn9_LastPmtDate
    
    Go To Account Screen    ${account_number}    amhs
    Verify Account AM Transactions Against Host

    [Teardown]    Log Out myBranch
    
Account Details - LOC
    [Documentation]    UFT test case: 'Account Details - LOC'
    [Tags]    qa_suite    account_details
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}
    View Account Details    ${account_namenumber}

    Open TSSO

    Go To Account Screen    ${account_number}    imi6
    Verify Currency In Host    AccountDetails_LOC_PrincipalBalance    imi6_principal
    Verify Currency In Host    AccountDetails_LOC_PayoffAmount    imi6_payoffAmt
    Verify Currency In Host    AccountDetails_LOC_AvailableCredit    imi6_availBalance
    Verify Currency In Host    AccountDetails_LOC_CreditLimit    imi6_creditLimit
    Verify Currency In Host    AccountDetails_LOC_DailyInterestAmount    imi6_dlyFinChrg
    Verify Currency In Host    AccountDetails_LOC_CurrentYearInterestPaid    imi6_ytdFinChrg
    Verify Currency In Host    AccountDetails_LOC_PriorYearInterestPaid    imi6_prevYtdFinChrg

    [Teardown]    Log Out myBranch