*** Settings ***
Library         Selenium2Library
Library         Screenshot
Library         Web
Library         Cudl
Library         OperatingSystem    WITH NAME    os
Library         String             WITH NAME    str
Resource        ../cudl_keywords.robot


*** Keywords ***
Submit Application
    Click On    EnterNewApplication
    Register Window
    Select List Item    Lender    Security Service Federal Credit Union - L360

    Wait For Object    PreApprovalSearch_Applicant_FirstName
    # pre-approvals popup
    Enter Text    PreApprovalSearch_Applicant_FirstName    ${applicant_firstname}
    Enter Text    PreApprovalSearch_Applicant_LastName    ${applicant_lastname}
    Enter Text    PreApprovalSearch_Applicant_SSN    ${applicant_ssn}
    Click On    Search_PreApprovals
    Click On    Continue_PreApprovals

    # back to main page
    Select List Item    DS_VehicleType    New
    Enter Text    DS_VehichleTaxYear    2010
    Select List Item    DS_VehicleMake    ACURA
    Enter Text    DS_VehicleModel    Gipsy
    Enter Text    DS_VehicleMileage    62010
    Enter Text    DS_VehicleValue    30000
    Select List Item    DS_VehicleValuation    MSRP
    Enter Text    DS_VehicleSalesPrice    30000
    Enter Text    DS_VehicleTerm    30
    Enter Text    DS_VehicleCashDown    3000
    Select List Item    ApplicantInfo_MemType    New Member        
    Enter Text    ApplicantInfo_DOB    08/08/1985
    Select List Item    ApplicantInfo_CheckingAccount    Yes
    Select List Item    ApplicantInfo_SavingsAccount    Yes        
    Enter Text    Applicant_Current Address    36828 36th
    Enter Text    Applicant_CurrentCity    PALMDALE    
    Select List Item    Applicant_CurrentState    CA
    Enter Text    Applicant_CurrentZip    93590   
    Enter Text    Applicant_CurrentAddressNoOfYears    7
    Enter Text    Applicant_CurrentAddressNoOfMonths    1
    Enter Text    Applicant_HomePhone    7824755444
    Select List Item    Applicant_HousingType    Lease
    Enter Text    Applicant_MonthlyHousePayment    1400

    # EmploymentInformation
    Select List Item    EmploymentInfo_EmpStatus    Employed
    Enter Text    EmploymentInfo_CurrentEmployer    SSFCU   
    Enter Text    EmploymentInfo_CurrentPosition    TeamLead
    Enter Text    EmploymentInfo_CurrentExpYears    4
    Enter Text    EmploymentInfo_CurrentExpMonths    7
    Enter Text    EmploymentInfo_CurrentPhone    7824745678   
    Enter Text    EmploymentInfo_CurrentGrossIncome    73652
    Select List Item    EmploymentInfo_CurrentPayFreq    Yearly    
    Enter Text    EmploymentInfo_PrevEmployer    JKC
    Enter Text    EmploymentInfo_PrevPosition    Team Member
    Enter Text    EmploymentInfo_PrevExpYears    1
    Enter Text    EmploymentInfo_PrevExpMonths    7
    Capture Page Screenshot
    Click On    Submit

    Wait For Object    Confirmation_ApplicationNo    timeout=30
    Capture Page Screenshot
    ${app_no} =    Get Element Text    Confirmation_ApplicationNo
    Log    Application Number: ${app_no}

    Close Window
    Unregister Window


*** Test Cases ***
Single Applicant
    [Documentation]    Single applicant.  
    [Setup]    Load Test Data    cudl    ${TEST NAME}    ${REGION}
    Open CUDL   ${BROWSER}    ${REGION}    
    Log In CUDL   ${lender_username}    ${lender_password}
    
    ${f} =    os.Get File    test.txt
    ${rows} =    str.Split To Lines    ${f}
    Log    rows: ${rows}
    :FOR    ${row}    IN    @{rows}
    \   Log    ON ROW: ${row}
    \   Submit Application

