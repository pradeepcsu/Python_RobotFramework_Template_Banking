*** Settings ***
Library           Selenium2Library
Library           Screenshot
Library           Host
Library           MyBranch
Resource          ../mybranch_keywords.robot

*** Keywords ***
    

*** Test Cases ***

One-Time Transfer - Checking to Credit Card - Batch
    [Documentation]    UFT test: "Transfers - Checking To CreditCard - Batch"
    [Tags]    post_batch
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}

    load batch    One-Time Transfer - Checking to Credit Card
    log    ${tran_amount}
    log    ${balance_from}
    log    ${cur_balance_from}

    Click On    Ribbon_Accounts
    Click On    LeftNav_MyAccounts_AccountDetails
    Select Kendo Dropdown    AccountDetails_SelectAccount    ${fromaccount_namenumber}

    Open TSSO
    Go To Account Screen    ${fromaccount_number}    imi1
    Should Be Equal As Numbers    ${balance_from}   ${cur_balance_from}
    Go To Account Screen    ${fromaccount_number}    imi2
    Verify Transfer Checking Transactions Against Host

    [Teardown]    Log Out myBranch

One-Time Transfer - Checking to FutureBuilderCD - Batch
    [Documentation]    UFT test: "Transfers - Checking To FutureBuilderCD - Batch"
    [Tags]    post_batch
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}

    load batch    One-Time Transfer - Checking to FutureBuilderCD
    log    ${tran_amount}
    log    ${balance_from}
    log    ${cur_balance_from}
    log    ${balance_to}
    log    ${cur_balance_to}

    Click On    Ribbon_Accounts
    Click On    LeftNav_MyAccounts_AccountDetails
    Select Kendo Dropdown    AccountDetails_SelectAccount    ${fromaccount_namenumber}

    Open TSSO
    Go To Account Screen    ${fromaccount_number}    imi1
    Should Be Equal As Numbers    ${balance_from}   ${cur_balance_from}
    Go To Account Screen    ${fromaccount_number}    imi2
    Verify Transfer Checking Transactions Against Host

    Select Kendo Dropdown    AccountDetails_SelectAccount    ${toaccount_namenumber}
    Should Be Equal As Numbers    ${balance_to}    ${cur_balance_to}

    Go To Account Screen    ${toaccount_number}    sti1
    print host object value    sti1_MemoBal
    ${memo_Bal}=  get field    sti1_MemoBal
    Log    ${memo_Bal}
    Should Be Equal As Numbers    ${balance_to}    ${memo_Bal}

    Go To Account Screen    ${toaccount_number}    sti2
    Verify Transfer CD Transactions Against Host

    [Teardown]    Log Out myBranch

One-Time Transfer - Checking to HELOC - Batch
    [Documentation]    UFT test: "Transfers - Checking To HELOC - Batch"
    [Tags]    post_batch
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}

    load batch    One-Time Transfer - Checking to HELOC
    log    ${tran_amount}
    log    ${balance_from}
    log    ${cur_balance_from}
    log    ${balance_to}
    log    ${cur_balance_to}

    Click On    Ribbon_Accounts
    Click On    LeftNav_MyAccounts_AccountDetails
    Select Kendo Dropdown    AccountDetails_SelectAccount    ${fromaccount_namenumber}

    Open TSSO
    Go To Account Screen    ${fromaccount_number}    imi1
    Should Be Equal As Numbers    ${balance_from}   ${cur_balance_from}

    Go To Account Screen    ${fromaccount_number}    imi2
    Verify Transfer Checking Transactions Against Host

    Select Kendo Dropdown    AccountDetails_SelectAccount    ${toaccount_namenumber}

    Go To Account Screen    ${toaccount_number}    amai
    Verify Currency In Host    AccountDetails_HELOC_PayoffAmount    amai_Payoff

    Go To Account Screen    ${toaccount_number}    amhs
    Verify Transfer HELOC Transactions Against Host

    [Teardown]    Log Out myBranch

One-Time Transfer - Checking to Loan - Batch
    [Documentation]    UFT test: "Transfers - Checking To Loan - Batch"
    [Tags]    post_batch
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}

    load batch    One-Time Transfer - Checking to Loan
    log    ${tran_amount}
    log    ${balance_from}
    log    ${cur_balance_from}
    log    ${balance_to}
    log    ${cur_balance_to}

    Click On    Ribbon_Accounts
    Click On    LeftNav_MyAccounts_AccountDetails
    Select Kendo Dropdown    AccountDetails_SelectAccount    ${fromaccount_namenumber}

    Open TSSO
    Go To Account Screen    ${fromaccount_number}    imi1
    Should Be Equal As Numbers    ${balance_from}   ${cur_balance_from}

    Go To Account Screen    ${fromaccount_number}    imi2
    Verify Transfer Checking Transactions Against Host

    Select Kendo Dropdown    AccountDetails_SelectAccount    ${toaccount_namenumber}

    Go To Account Screen    ${toaccount_number}    amai
    print host object value    amai_Payoff
    Verify Currency In Host    AccountDetails_Loan_PayoffAmount    amai_Payoff

    Go To Account Screen    ${toaccount_number}    amhs
    Verify Transfer AM Transactions Against Host

    [Teardown]    Log Out myBranch


One-Time Transfer - Checking to LOC - Batch
    [Documentation]    UFT test: "Transfers - Checking To LOC - Batch"
    [Tags]    post_batch
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}

    load batch    One-Time Transfer - Checking to LOC
    log    ${tran_amount}
    log    ${balance_from}
    log    ${cur_balance_from}
    #log    ${balance_to}
    #log    ${cur_balance_to}

    Click On    Ribbon_Accounts
    Click On    LeftNav_MyAccounts_AccountDetails
    Select Kendo Dropdown    AccountDetails_SelectAccount    ${fromaccount_namenumber}

    Open TSSO
    Go To Account Screen    ${fromaccount_number}    imi1
    Should Be Equal As Numbers    ${balance_from}   ${cur_balance_from}

    Go To Account Screen    ${fromaccount_number}    imi2
    Verify Transfer Checking Transactions Against Host

    Select Kendo Dropdown    AccountDetails_SelectAccount    ${toaccount_namenumber}

    Go To Account Screen    ${toaccount_number}    imi6

    Verify Currency In Host    AccountDetails_LOC_PrincipalBalance    imi6_principal
    Verify Currency In Host    AccountDetails_LOC_PayoffAmount    imi6_payoffAmt
    Verify Currency In Host    AccountDetails_LOC_AvailableCredit    imi6_availBalance
    Verify Currency In Host    AccountDetails_LOC_CreditLimit    imi6_creditLimit

    [Teardown]    Log Out myBranch

One-Time Transfer - Checking to MoneyMarket - Batch
    [Documentation]    UFT test: "Transfers - Checking To MoneyMarket - Batch"
    [Tags]    post_batch
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}

    load batch    One-Time Transfer - Checking to MoneyMarket
    log    ${tran_amount}
    log    ${balance_from}
    log    ${cur_balance_from}
    log    ${balance_to}
    log    ${cur_balance_to}

    Click On    Ribbon_Accounts
    Click On    LeftNav_MyAccounts_AccountDetails
    Select Kendo Dropdown    AccountDetails_SelectAccount    ${fromaccount_namenumber}

    Open TSSO
    Go To Account Screen    ${fromaccount_number}    imi1
    Should Be Equal As Numbers    ${balance_from}   ${cur_balance_from}

    Go To Account Screen    ${fromaccount_number}    imi2
    Verify Transfer Checking Transactions Against Host

    Select Kendo Dropdown    AccountDetails_SelectAccount    ${toaccount_namenumber}

    Go To Account Screen    ${toaccount_number}    imi1
    Should Be Equal As Numbers    ${balance_to}   ${cur_balance_to}

    Go To Account Screen    ${toaccount_number}    imi2
    Verify Transfer Checking Transactions Against Host

    [Teardown]    Log Out myBranch

One-Time Transfer - Checking to Savings - Batch
    [Documentation]    UFT test: "Transfers - Checking To Savings - Batch"
    [Tags]    post_batch
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}

    load batch    One-Time Transfer - Checking to Savings
    log    ${tran_amount}
    log    ${balance_from}
    log    ${cur_balance_from}
    log    ${balance_to}
    log    ${cur_balance_to}

    Click On    Ribbon_Accounts
    Click On    LeftNav_MyAccounts_AccountDetails
    Select Kendo Dropdown    AccountDetails_SelectAccount    ${fromaccount_namenumber}

    Open TSSO
    Go To Account Screen    ${fromaccount_number}    imi1
    Should Be Equal As Numbers    ${balance_from}   ${cur_balance_from}

    Go To Account Screen    ${fromaccount_number}    imi2
    Verify Transfer Checking Transactions Against Host

    Select Kendo Dropdown    AccountDetails_SelectAccount    ${toaccount_namenumber}
    Go To Account Screen    ${toaccount_number}    imi1

    Should Be Equal As Numbers    ${balance_to}   ${cur_balance_to}

    Go To Account Screen    ${toaccount_number}    imi2
    Verify Transfer Savings Transactions Against Host

    [Teardown]    Log Out myBranch

One-Time Transfer - MoneyMarket to Classic Checking - Batch
    [Documentation]    UFT test: " Transfers - MoneyMarket To ClassicChecking - Batch"
    [Tags]    post_batch
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}

    load batch    One-Time Transfer - MoneyMarket to Classic Checking
    log    ${tran_amount}
    log    ${balance_from}
    log    ${cur_balance_from}
    log    ${balance_to}
    log    ${cur_balance_to}

    Click On    Ribbon_Accounts
    Click On    LeftNav_MyAccounts_AccountDetails
    Select Kendo Dropdown    AccountDetails_SelectAccount    ${fromaccount_namenumber}

    Open TSSO
    Go To Account Screen    ${fromaccount_number}    imi1
    Should Be Equal As Numbers    ${balance_from}   ${cur_balance_from}

    Go To Account Screen    ${fromaccount_number}    imi2
    Verify Transfer Checking Transactions Against Host

    Select Kendo Dropdown    AccountDetails_SelectAccount    ${toaccount_namenumber}
    Go To Account Screen    ${toaccount_number}    imi1
    Should Be Equal As Numbers    ${balance_to}   ${cur_balance_to}

    Go To Account Screen    ${toaccount_number}    imi2
    Verify Transfer Checking Transactions Against Host

    [Teardown]    Log Out myBranch

One-Time Transfer - LOC to Classic Checking - Batch
    [Documentation]    UFT test: " Transfers - OneTime - LOC To ClassicChecking - Batch"
    [Tags]    post_batch
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}

    load batch    One-Time Transfer - LOC to Classic Checking
    log    ${tran_amount}
    log    ${balance_from}
    log    ${cur_balance_from}
    log    ${balance_to}
    log    ${cur_balance_to}

    Click On    Ribbon_Accounts
    Click On    LeftNav_MyAccounts_AccountDetails
    Select Kendo Dropdown    AccountDetails_SelectAccount    ${fromaccount_namenumber}

    Open TSSO

    Go To Account Screen    ${fromaccount_number}    imi6

    Verify Currency In Host    AccountDetails_LastPaymentAmount    imi6_lastPayment_amount
    Verify Date In Host    AccountDetails_LastPaymentDate    imi6_lastPayment_date

    Select Kendo Dropdown    AccountDetails_SelectAccount    ${toaccount_namenumber}

    Go To Account Screen    ${toaccount_number}    imi1

    Go To Account Screen    ${toaccount_number}    imi2
    Verify Transfer Checking Transactions Against Host

    [Teardown]    Log Out myBranch

One-Time Transfer - LOC to Gold Checking - Batch
    [Documentation]    UFT test: " Transfers - OneTime - LOC To GoldChecking - Batch"
    [Tags]    post_batch
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}

    load batch    One-Time Transfer - LOC to Gold Checking
    log    ${tran_amount}
    log    ${balance_from}
    log    ${cur_balance_from}
    log    ${balance_to}
    log    ${cur_balance_to}

    Click On    Ribbon_Accounts
    Click On    LeftNav_MyAccounts_AccountDetails
    Select Kendo Dropdown    AccountDetails_SelectAccount    ${fromaccount_namenumber}

    Open TSSO

    Go To Account Screen    ${fromaccount_number}    imi6
    Verify Currency In Host    AccountDetails_LastPaymentAmount    imi6_lastPayment_amount
    Verify Date In Host    AccountDetails_LastPaymentDate    imi6_lastPayment_date

    Select Kendo Dropdown    AccountDetails_SelectAccount    ${toaccount_namenumber}

    Go To Account Screen    ${toaccount_number}    imi1

    Go To Account Screen    ${toaccount_number}    imi2
    Verify Transfer Checking Transactions Against Host

    [Teardown]    Log Out myBranch

One-Time Transfer - LOC To MoneyMarket - Batch
    [Documentation]    UFT test: " Transfers - OneTime - LOC To MoneyMarket - Batch"
    [Tags]    post_batch
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}

    load batch    One-Time Transfer - LOC To MoneyMarket
    log    ${tran_amount}
    log    ${balance_from}
    log    ${cur_balance_from}
    log    ${balance_to}
    log    ${cur_balance_to}

    Click On    Ribbon_Accounts
    Click On    LeftNav_MyAccounts_AccountDetails
    Select Kendo Dropdown    AccountDetails_SelectAccount    ${fromaccount_namenumber}

    Open TSSO

    Go To Account Screen    ${fromaccount_number}    imi6

    Verify Currency In Host    AccountDetails_LastPaymentAmount    imi6_lastPayment_amount
    Verify Date In Host    AccountDetails_LastPaymentDate    imi6_lastPayment_date

    Select Kendo Dropdown    AccountDetails_SelectAccount    ${toaccount_namenumber}

    Go To Account Screen    ${toaccount_number}    imi1

    Go To Account Screen    ${toaccount_number}    imi2
    Verify Transfer Checking Transactions Against Host

    [Teardown]    Log Out myBranch

One-Time Transfer - LOC To Savings - Batch
    [Documentation]    UFT test: "Transfers - OneTime - LOC To Savings - Batch"
    [Tags]    post_batch
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}

    load batch    One-Time Transfer - LOC To Savings
    log    ${tran_amount}
    log    ${balance_from}
    log    ${cur_balance_from}
    log    ${balance_to}
    log    ${cur_balance_to}

    Click On    Ribbon_Accounts
    Click On    LeftNav_MyAccounts_AccountDetails
    Select Kendo Dropdown    AccountDetails_SelectAccount    ${fromaccount_namenumber}

    Open TSSO

    Go To Account Screen    ${fromaccount_number}    imi6
    Verify Currency In Host    AccountDetails_LastPaymentAmount    imi6_lastPayment_amount
    Verify Date In Host    AccountDetails_LastPaymentDate    imi6_lastPayment_date

    Select Kendo Dropdown    AccountDetails_SelectAccount    ${toaccount_namenumber}

    Go To Account Screen    ${toaccount_number}    imi1

    Go To Account Screen    ${toaccount_number}    imi2
    Verify Transfer Savings Transactions Against Host

    [Teardown]    Log Out myBranch

One-Time Transfer - Savings to Checking - Batch
    [Documentation]    UFT test: "Transfers - OneTime - Savings To Checking - Batch"
    [Tags]    post_batch
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}

    load batch    One-Time Transfer - Savings to Checking
    log    ${tran_amount}
    log    ${balance_from}
    log    ${cur_balance_from}
    log    ${balance_to}
    log    ${cur_balance_to}

    Click On    Ribbon_Accounts
    Click On    LeftNav_MyAccounts_AccountDetails
    Select Kendo Dropdown    AccountDetails_SelectAccount    ${fromaccount_namenumber}

    Open TSSO

    Go To Account Screen    ${fromaccount_number}    imi1
    Should Be Equal As Numbers    ${balance_from}   ${cur_balance_from}

    Go To Account Screen    ${fromaccount_number}    imi2
    Verify Transfer Savings Transactions Against Host

    Select Kendo Dropdown    AccountDetails_SelectAccount    ${toaccount_namenumber}
    Go To Account Screen    ${toaccount_number}    imi1
    Should Be Equal As Numbers    ${balance_to}   ${cur_balance_to}

    Go To Account Screen    ${toaccount_number}    imi2
    Verify Transfer Checking Transactions Against Host

    [Teardown]    Log Out myBranch

One-Time Transfer - Savings to CreditCard - Batch
    [Documentation]    UFT test: "Transfers - OneTime - Savings To CreditCard - Batch"
    [Tags]    post_batch
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}

    load batch    One-Time Transfer - Savings to CreditCard
    log    ${tran_amount}
    log    ${balance_from}
    log    ${cur_balance_from}

    Click On    Ribbon_Accounts
    Click On    LeftNav_MyAccounts_AccountDetails
    Select Kendo Dropdown    AccountDetails_SelectAccount    ${fromaccount_namenumber}

    Open TSSO

    Go To Account Screen    ${fromaccount_number}    imi1

    Go To Account Screen    ${fromaccount_number}    imi2
    Verify Transfer Savings Transactions Against Host

    [Teardown]    Log Out myBranch

One-Time Transfer - Savings to FutureBuilder CD - Batch
    [Documentation]    UFT test: "Transfers - OneTime - Savings To FutureBuilderCD - Batch"
    [Tags]    post_batch
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}

    load batch    One-Time Transfer - Savings to FutureBuilder CD
    log    ${tran_amount}
    log    ${balance_from}
    log    ${cur_balance_from}
    log    ${balance_to}

    Click On    Ribbon_Accounts
    Click On    LeftNav_MyAccounts_AccountDetails
    Select Kendo Dropdown    AccountDetails_SelectAccount    ${fromaccount_namenumber}

    Open TSSO

    Go To Account Screen    ${fromaccount_number}    imi1
    Should Be Equal As Numbers    ${balance_from}   ${cur_balance_from}

    Go To Account Screen    ${fromaccount_number}    imi2
    Verify Transfer Savings Transactions Against Host

    Select Kendo Dropdown    AccountDetails_SelectAccount    ${toaccount_namenumber}
    Should Be Equal As Numbers    ${balance_to}    ${cur_balance_to}

    Go To Account Screen    ${toaccount_number}    sti1
    print host object value    sti1_MemoBal
    ${memo_Bal}=  get field    sti1_MemoBal
    Log    ${memo_Bal}
    Should Be Equal As Numbers    ${balance_to}    ${memo_Bal}

    Go To Account Screen    ${toaccount_number}    sti2
    Verify Transfer CD Transactions Against Host

    [Teardown]    Log Out myBranch

One-Time Transfer - Savings to HELOC - Batch
    [Documentation]    UFT test: "Transfers - OneTime - Savings To HELOC - Batch"
    [Tags]    post_batch
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}

    load batch    One-Time Transfer - Savings to HELOC
    log    ${tran_amount}
    log    ${balance_from}
    log    ${cur_balance_from}

    Click On    Ribbon_Accounts
    Click On    LeftNav_MyAccounts_AccountDetails
    Select Kendo Dropdown    AccountDetails_SelectAccount    ${fromaccount_namenumber}

    Open TSSO

    Go To Account Screen    ${fromaccount_number}    imi1
    Should Be Equal As Numbers    ${balance_from}   ${cur_balance_from}

    Go To Account Screen    ${fromaccount_number}    imi2
    Verify Transfer Savings Transactions Against Host

    Select Kendo Dropdown    AccountDetails_SelectAccount    ${toaccount_namenumber}

    Go To Account Screen    ${toaccount_number}    amai
    Verify Currency In Host    AccountDetails_HELOC_PayoffAmount    amai_Payoff

    Go To Account Screen    ${toaccount_number}    amhs
    Verify Transfer HELOC Transactions Against Host

    [Teardown]    Log Out myBranch

One-Time Transfer - Savings to Loan - Batch
    [Documentation]    UFT test: "Transfers - OneTime - Savings To Loan - Batch"
    [Tags]    post_batch
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}

    load batch    One-Time Transfer - Savings To Loan
    log    ${tran_amount}
    log    ${balance_from}
    log    ${cur_balance_from}

    Click On    Ribbon_Accounts
    Click On    LeftNav_MyAccounts_AccountDetails
    Select Kendo Dropdown    AccountDetails_SelectAccount    ${fromaccount_namenumber}

    Open TSSO

    Go To Account Screen    ${fromaccount_number}    imi1
    Should Be Equal As Numbers    ${balance_from}   ${cur_balance_from}

    Go To Account Screen    ${fromaccount_number}    imi2
    Verify Transfer Savings Transactions Against Host

    Select Kendo Dropdown    AccountDetails_SelectAccount    ${toaccount_namenumber}

    Go To Account Screen    ${toaccount_number}    amai
    print host object value    amai_Payoff
    Verify Currency In Host    AccountDetails_Loan_PayoffAmount    amai_Payoff

    Go To Account Screen    ${toaccount_number}    amhs
    Verify Transfer AM Transactions Against Host

    [Teardown]    Log Out myBranch

One-Time Transfer - Savings to LOC - Batch
    [Documentation]    UFT test: "Transfers - OneTime - Savings To LOC - Batch"
    [Tags]    post_batch
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}

    load batch    One-Time Transfer - Savings To LOC
    log    ${tran_amount}
    log    ${balance_from}
    log    ${cur_balance_from}

    Click On    Ribbon_Accounts
    Click On    LeftNav_MyAccounts_AccountDetails
    Select Kendo Dropdown    AccountDetails_SelectAccount    ${fromaccount_namenumber}

    Open TSSO

    Select Kendo Dropdown    AccountDetails_SelectAccount    ${fromaccount_namenumber}

    Go To Account Screen    ${fromaccount_number}    imi1
    Should Be Equal As Numbers    ${balance_from}   ${cur_balance_from}

    Go To Account Screen    ${fromaccount_number}    imi2
    Verify Transfer Savings Transactions Against Host

    Select Kendo Dropdown    AccountDetails_SelectAccount    ${toaccount_namenumber}

    Go To Account Screen    ${toaccount_number}    imi6
    Verify Currency In Host    AccountDetails_LOC_PrincipalBalance    imi6_principal
    Verify Currency In Host    AccountDetails_LOC_PayoffAmount    imi6_payoffAmt
    Verify Currency In Host    AccountDetails_LOC_AvailableCredit    imi6_availBalance
    Verify Currency In Host    AccountDetails_LOC_CreditLimit    imi6_creditLimit

    [Teardown]    Log Out myBranch

One-Time Transfer - Savings to MoneyMarket - Batch
    [Documentation]    UFT test: "Transfers - OneTime - Savings To MoneyMarket - Batch"
    [Tags]    post_batch
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}

    load batch    One-Time Transfer - Savings To MoneyMarket
    log    ${tran_amount}
    log    ${balance_from}
    log    ${cur_balance_from}

    Click On    Ribbon_Accounts
    Click On    LeftNav_MyAccounts_AccountDetails
    Select Kendo Dropdown    AccountDetails_SelectAccount    ${fromaccount_namenumber}

    Open TSSO

    Select Kendo Dropdown    AccountDetails_SelectAccount    ${fromaccount_namenumber}

    Go To Account Screen    ${fromaccount_number}    imi1
    Should Be Equal As Numbers    ${balance_from}   ${cur_balance_from}

    Go To Account Screen    ${fromaccount_number}    imi2
    Verify Transfer Savings Transactions Against Host

    Select Kendo Dropdown    AccountDetails_SelectAccount    ${toaccount_namenumber}

    Go To Account Screen    ${toaccount_number}    imi1
    Should Be Equal As Numbers    ${balance_to}   ${cur_balance_to}

    Go To Account Screen    ${toaccount_number}    imi2
    Verify Transfer Checking Transactions Against Host

    [Teardown]    Log Out myBranch

One-Time Transfer - Savings to Savings - Batch
    [Documentation]    UFT test: "Transfers - OneTime - Savings To Savings - Batch"
    [Tags]    post_batch
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}

    load batch    One-Time Transfer - Savings To Savings
    log    ${tran_amount}
    log    ${balance_from}
    log    ${cur_balance_from}

    Click On    Ribbon_Accounts
    Click On    LeftNav_MyAccounts_AccountDetails
    Select Kendo Dropdown    AccountDetails_SelectAccount    ${fromaccount_namenumber}

    Open TSSO

    Go To Account Screen    ${fromaccount_number}    imi1
    Should Be Equal As Numbers    ${balance_from}   ${cur_balance_from}

    Go To Account Screen    ${fromaccount_number}    imi2
    Verify Transfer Savings Transactions Against Host

    Select Kendo Dropdown    AccountDetails_SelectAccount    ${toaccount_namenumber}
    Go To Account Screen    ${toaccount_number}    imi1
    Should Be Equal As Numbers    ${balance_to}   ${cur_balance_to}

    Go To Account Screen    ${toaccount_number}    imi2
    Verify Transfer Savings Transactions Against Host

    [Teardown]    Log Out myBranch














































