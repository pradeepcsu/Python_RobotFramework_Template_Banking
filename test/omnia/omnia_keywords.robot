*** Variables ***
${QA}    http://crm-qa.qatssfcu.org
${UAT2}    http://90tvmccrmfe1u.devssfcuad.devssfcu.org

*** Keywords ***
Open Omnia
    [Arguments]    ${BROWSER}    ${REGION}
    ${URL}    Set Variable If
    ...    "${REGION}" == "QA"    ${QA}
    ...    "${REGION}" == "UAT2"    ${UAT2}
    Set Global Variable    ${URL}
    Set Global Variable    ${BROWSER}
    Open Browser    ${URL}    ${BROWSER}
    Log    ${browser}

Query Member Omnia
    [Documentation]     Searchs a member by the first argument, then opens the
    ...                 member's UMP by using the second argument which should be the CIS.
    [Arguments]    ${ssn}    ${cis}
    Enter Text    Members_Search    ${ssn}
    Click On    Members_Search_Button
    Capture Page Screenshot
    Open UMP From Search Results    ${cis}
    Register Window

Verify Header Name
    [Documentation]    Assumes a page with a standard Omnia header is open,
    ...                and the same member is accessed in Host.
    ${omnia member name} =    Get Element Text    Header_MemberName
    Verify Name    ${omnia member name}

Verify Header SSN
    [Documentation]    Assumes a page with a standard Omnia header is open,
    ...                and the same member is accessed in Host.
    Nav Screen    RMAB
    ${host ssn} =    Get Field    rmab_SSN
    ${host ssn} =    Format SSN    ${host ssn}
    Expect Text RegEx    Header_SSN    SSN ${host ssn}

Verify Header Birthdate
    [Documentation]    Assumes a page with a standard Omnia header is open,
    ...                and the same member is accessed in Host.
    Nav Screen    RMC3
    ${host birthdate} =    Get Field    rmc3_DateOfBirth
    ${omnia birthdate} =    Get Element Text    Header_DateOfBirth
    Compare Dates    ${host birthdate}    %m/%d/%Y    ${omnia birthdate}    %m/%d/%Y

Verify Header Mothers Maiden Name
    [Documentation]    Assumes a page with a standard Omnia header is open,
    ...                and the same member is accessed in Host.
    Nav Screen    RMC3
    ${host mmn} =    Get Field    rmc3_MothersMaidenName
    Expect Text    Header_MothersMaidenName    ${host mmn}

Verify Header Codeword
    [Documentation]    Assumes a page with a standard Omnia header is open,
    ...                and the same member is accessed in Host.
    ${host code word} =    Get Code Word
    Expect Text    Header_CodeWord    ${host code word}

Verify Header Email
    [Documentation]    Assumes a page with a standard Omnia header is open,
    ...                and the same member is accessed in Host.
    ${host email} =    Get Email Address
    Expect Text    Header_EmailAddress    ${host email} 

Verify Header
    [Documentation]    Assumes a page with a standard Omnia header is open,
    ...                and the same member is accessed in Host.
    Verify Header Name
    Verify Header SSN
    Verify Header Birthdate
    Verify Header Mothers Maiden Name
    Verify Header Code Word
    Verify Header Email
    Verify Member Icons
