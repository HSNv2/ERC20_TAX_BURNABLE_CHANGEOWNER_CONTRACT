# ERC20_TAX_BURNABLE_CHANGEOWNER_CONTRACT
Hello,
With this Solidity source code, you can create a token with the ERC20 algorithm. It is a reliable contract that can be burned, Sell-Buy Tax(Fee). and most importantly, the Owner and Tax rates can be changed afterward.

<h2>Functions and Modifiers</h2>
<b>onlyOwner</b><br>
Modifier for authorization of functions that are restricted to only the owner who signed the contract. Can be used in function details.<br><br>
<b>nonReentrant</b><br>
This is a security measure used to avoid conflicts with other processes sending requests at the same time and to prevent flood-hack attacks. Can be used in public transactions such as transfers.

<h3>updateTax()</h3>
This function can only be signed by a wallet address with **onlyOwner** modifier authorization. This function specifies the tax rate for both transfer transactions and DEX Liquidity Swap transactions.

<h3>changeTaxAddress</h3>
This determines the wallet to which the tax gains will be transferred and can then be changed. *onlyOwner** authorized person can sign.

<h3>changeOwner</h3>
This operation can only be signed with the **onlyOwner** modifier. 
It is used to change the owner of the **onylOwner** modifier after the contract is deployed.
