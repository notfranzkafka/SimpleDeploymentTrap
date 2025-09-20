// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract DeploymentAlertResponse {
    
    event DeploymentAnomaly(
        string indexed discordName,
        uint256 indexed deploymentCount,
        uint256 threshold,
        uint256 blockNumber,
        bool rapidDeployment,
        bool identicalContracts,
        bool gasAnomaly,
        string message,
        uint256 timestamp
    );
    
    uint256 public totalAlerts;
    mapping(string => uint256) public alertsPerUser;
    
    function handleDeploymentAlert(
        string memory discordName,
        uint256 deploymentCount,
        uint256 threshold,
        uint256 blockNumber,
        bool rapidDeployment,
        bool identicalContracts,
        bool gasAnomaly,
        string memory message
    ) external {
        totalAlerts++;
        alertsPerUser[discordName]++;
        
        emit DeploymentAnomaly(
            discordName,
            deploymentCount,
            threshold,
            blockNumber,
            rapidDeployment,
            identicalContracts,
            gasAnomaly,
            message,
            block.timestamp
        );
    }
    
    function respond(string memory discordName) external {
        totalAlerts++;
        alertsPerUser[discordName]++;
    }
    
    function getUserAlerts(string memory discordName) external view returns (uint256) {
        return alertsPerUser[discordName];
    }
    
    function getStats() external view returns (uint256) {
        return totalAlerts;
    }
}
