// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface ITrap {
    function collect() external view returns (bytes memory);
    function shouldRespond(bytes[] calldata data) external pure returns (bool, bytes memory);
}

contract Trap is ITrap {
    
    uint256 private constant DEPLOYMENT_THRESHOLD = 3;
    string private constant DISCORD_NAME = "YourActualDiscordName"; // CHANGE THIS
    uint256 private constant VERSION = 1;
    
    function collect() external view override returns (bytes memory) {
        uint256 mockCount = block.number % 8;
        bool rapidDeployment = (block.number % 3 == 0);
        bool identicalContracts = (block.number % 5 == 0);
        bool gasAnomaly = (block.number % 7 == 0);
        
        return abi.encode(
            VERSION,
            mockCount,
            rapidDeployment,
            identicalContracts,
            gasAnomaly,
            block.number,
            DISCORD_NAME
        );
    }
    
    function shouldRespond(bytes[] calldata data) 
        external 
        pure 
        override 
        returns (bool, bytes memory) 
    {
        if (data.length == 0) return (false, bytes(""));
        
        (
            uint256 version,
            uint256 deploymentCount,
            bool rapidDeployment,
            bool identicalContracts,
            bool gasAnomaly,
            uint256 blockNumber,
            string memory discordName
        ) = abi.decode(data[0], (uint256, uint256, bool, bool, bool, uint256, string));
        
        if (version != VERSION) return (false, bytes(""));
        
        if (deploymentCount >= DEPLOYMENT_THRESHOLD || rapidDeployment || identicalContracts) {
            return (true, abi.encode(
                discordName,
                deploymentCount,
                DEPLOYMENT_THRESHOLD,
                blockNumber,
                rapidDeployment,
                identicalContracts,
                gasAnomaly,
                "Multi-Signal Deployment Alert"
            ));
        }
        
        return (false, bytes(""));
    }
}
