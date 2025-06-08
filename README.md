# Blockchain-Based Agriculture Crop Insurance Automation

A comprehensive decentralized insurance platform for agricultural crop protection built on the Stacks blockchain using Clarity smart contracts.

## Overview

This system automates crop insurance processes through blockchain technology, providing transparent, efficient, and trustless insurance coverage for farmers. The platform includes provider verification, weather monitoring, yield assessment, automated claims processing, and risk pooling mechanisms.

## Features

### 🏢 Insurance Provider Verification
- **Provider Registration**: Insurance companies can register with license verification
- **Verification System**: Contract owner can verify legitimate providers
- **Provider Management**: Track provider statistics and policy counts

### 🌤️ Weather Monitoring
- **Weather Stations**: Distributed network of weather monitoring stations
- **Real-time Data**: Temperature, humidity, rainfall, and wind speed tracking
- **Drought Detection**: Automated detection of adverse weather conditions
- **Geographic Coverage**: Latitude/longitude-based station positioning

### 📊 Yield Assessment
- **Farm Registration**: Farmers register their farms with crop details
- **Yield Tracking**: Expected vs. actual yield comparison
- **Impact Analysis**: Weather, pest, and disease impact assessment
- **Loss Calculation**: Automated loss percentage calculations

### ⚡ Automated Claims Processing
- **Smart Claims**: Automated claim submission based on loss thresholds
- **Weather Triggers**: Automatic claims for severe weather events
- **Policy Management**: Comprehensive insurance policy tracking
- **Claim Status**: Real-time claim processing status updates

### 🏊 Risk Pooling
- **Collective Insurance**: Farmers pool resources for shared risk coverage
- **Flexible Membership**: Configurable pool sizes and contribution requirements
- **Automated Payouts**: Smart contract-based payout distribution
- **Pool Analytics**: Utilization tracking and performance metrics

## Smart Contracts

### 1. Insurance Provider Verification (`insurance-provider-verification.clar`)
Manages insurance provider registration and verification processes.

**Key Functions:**
- \`register-provider\`: Register new insurance provider
- \`verify-provider\`: Verify provider legitimacy (owner only)
- \`get-provider\`: Retrieve provider information
- \`is-verified-provider\`: Check provider verification status

### 2. Weather Monitoring (`weather-monitoring.clar`)
Handles weather station management and data collection.

**Key Functions:**
- \`add-weather-station\`: Add new weather monitoring station
- \`submit-weather-data\`: Submit weather readings
- \`get-latest-weather\`: Get current weather conditions
- \`check-drought-conditions\`: Automated drought detection

### 3. Yield Assessment (`yield-assessment.clar`)
Manages farm registration and crop yield assessments.

**Key Functions:**
- \`register-farm\`: Register farm with crop details
- \`submit-yield-assessment\`: Submit harvest yield data
- \`calculate-loss-percentage\`: Calculate crop loss percentage
- \`get-latest-assessment\`: Retrieve recent yield assessment

### 4. Claim Automation (`claim-automation.clar`)
Automates insurance claim processing and payouts.

**Key Functions:**
- \`create-policy\`: Create new insurance policy
- \`submit-claim\`: Submit insurance claim
- \`trigger-weather-claim\`: Automatic weather-based claims
- \`process-claim\`: Approve/reject claims (owner only)

### 5. Risk Pooling (`risk-pooling.clar`)
Manages collective insurance risk pools.

**Key Functions:**
- \`create-risk-pool\`: Create new insurance pool
- \`join-pool\`: Join existing risk pool
- \`distribute-payout\`: Distribute pool payouts
- \`calculate-pool-utilization\`: Pool utilization analytics

## Getting Started

### Prerequisites
- Stacks blockchain development environment
- Clarity smart contract compiler
- Node.js and npm for testing
- Vitest testing framework

### Installation

1. **Clone the repository:**
   \`\`\`bash
   git clone https://github.com/your-org/blockchain-crop-insurance.git
   cd blockchain-crop-insurance
   \`\`\`

2. **Install dependencies:**
   \`\`\`bash
   npm install
   \`\`\`

3. **Deploy contracts:**
   \`\`\`bash
# Deploy to testnet
clarinet deploy --testnet

# Deploy to mainnet
clarinet deploy --mainnet
\`\`\`

### Testing

Run the comprehensive test suite:

\`\`\`bash
# Run all tests
npm test

# Run specific contract tests
npm test insurance-provider-verification
npm test weather-monitoring
npm test yield-assessment
npm test claim-automation
npm test risk-pooling
\`\`\`

## Usage Examples

### For Insurance Providers

1. **Register as Provider:**
   \`\`\`clarity
   (contract-call? .insurance-provider-verification register-provider
   "AgriInsure Corp"
   "LIC-2024-001")
   \`\`\`

2. **Create Insurance Policy:**
   \`\`\`clarity
   (contract-call? .claim-automation create-policy
   u1          ;; farm-id
   u1          ;; provider-id
   u1000000    ;; coverage-amount (1M microSTX)
   u50000      ;; premium-paid (50K microSTX)
   u8760)      ;; policy-duration (1 year)
   \`\`\`

### For Farmers

1. **Register Farm:**
   \`\`\`clarity
   (contract-call? .yield-assessment register-farm
   "Iowa Corn Belt, Section 12"  ;; location
   "Corn"                        ;; crop-type
   u100                          ;; area-hectares
   u9000                         ;; expected-yield (kg/hectare)
   u1000                         ;; planting-date
   u2000)                        ;; harvest-date
   \`\`\`

2. **Join Risk Pool:**
   \`\`\`clarity
   (contract-call? .risk-pooling join-pool
   u1        ;; pool-id
   u150000)  ;; contribution (150K microSTX)
   \`\`\`

3. **Submit Insurance Claim:**
   \`\`\`clarity
   (contract-call? .claim-automation submit-claim
   u1   ;; policy-id
   u60) ;; loss-percentage
   \`\`\`

### For Weather Oracles

1. **Add Weather Station:**
   \`\`\`clarity
   (contract-call? .weather-monitoring add-weather-station
   4000000     ;; latitude (40.0000 degrees)
   -7400000    ;; longitude (-74.0000 degrees)
   "Midwest Farm Belt")
   \`\`\`

2. **Submit Weather Data:**
   \`\`\`clarity
   (contract-call? .weather-monitoring submit-weather-data
   u1      ;; station-id
   2500    ;; temperature (25.00°C)
   u65     ;; humidity (65%)
   u1250   ;; rainfall (12.50mm)
   u1500)  ;; wind-speed (15.00 km/h)
   \`\`\`

## Contract Architecture

### Data Flow

1. **Registration Phase:**
    - Insurance providers register and get verified
    - Farmers register their farms with crop details
    - Weather stations are deployed across regions

2. **Policy Creation:**
    - Verified providers create insurance policies
    - Farmers purchase coverage for their registered farms
    - Risk pools are formed for collective coverage

3. **Monitoring Phase:**
    - Weather stations continuously report conditions
    - Yield assessments are conducted during harvest
    - Smart contracts monitor for claim triggers

4. **Claims Processing:**
    - Automated claims triggered by weather events
    - Manual claims submitted based on yield losses
    - Risk pools distribute payouts to affected farmers

### Security Features

- **Access Control**: Role-based permissions for different contract functions
- **Data Validation**: Input validation for all contract parameters
- **Fraud Prevention**: Multiple verification layers for claims
- **Transparency**: All transactions recorded on blockchain

## Error Codes

### Insurance Provider Verification
- \`u100\`: ERR_UNAUTHORIZED - Caller not authorized
- \`u101\`: ERR_PROVIDER_EXISTS - Provider already registered
- \`u102\`: ERR_PROVIDER_NOT_FOUND - Provider doesn't exist
- \`u103\`: ERR_INVALID_LICENSE - Invalid license number

### Weather Monitoring
- \`u200\`: ERR_UNAUTHORIZED - Caller not authorized
- \`u201\`: ERR_INVALID_COORDINATES - Invalid lat/long coordinates
- \`u202\`: ERR_STATION_NOT_FOUND - Weather station not found
- \`u203\`: ERR_INVALID_DATA - Invalid weather data

### Yield Assessment
- \`u300\`: ERR_UNAUTHORIZED - Caller not authorized
- \`u301\`: ERR_FARM_NOT_FOUND - Farm not registered
- \`u302\`: ERR_INVALID_YIELD - Invalid yield parameters
- \`u303\`: ERR_ASSESSMENT_EXISTS - Assessment already exists

### Claim Automation
- \`u400\`: ERR_UNAUTHORIZED - Caller not authorized
- \`u401\`: ERR_POLICY_NOT_FOUND - Policy doesn't exist
- \`u402\`: ERR_CLAIM_EXISTS - Claim already submitted
- \`u403\`: ERR_INSUFFICIENT_LOSS - Loss below threshold (50%)
- \`u404\`: ERR_INVALID_AMOUNT - Invalid amount specified

### Risk Pooling
- \`u500\`: ERR_UNAUTHORIZED - Caller not authorized
- \`u501\`: ERR_POOL_NOT_FOUND - Risk pool doesn't exist
- \`u502\`: ERR_INSUFFICIENT_FUNDS - Insufficient funds/contribution
- \`u503\`: ERR_ALREADY_MEMBER - Already pool member
- \`u504\`: ERR_NOT_MEMBER - Not a pool member

## Contributing

1. Fork the repository
2. Create a feature branch (\`git checkout -b feature/amazing-feature\`)
3. Commit your changes (\`git commit -m 'Add amazing feature'\`)
4. Push to the branch (\`git push origin feature/amazing-feature\`)
5. Open a Pull Request

### Development Guidelines

- Follow Clarity best practices
- Write comprehensive tests for all functions
- Document all public functions
- Use descriptive variable names
- Implement proper error handling

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

For support and questions:
- Create an issue on GitHub
- Join our Discord community
- Email: support@cropinsurance.blockchain

## Roadmap

### Phase 1 (Current)
- ✅ Core smart contracts implementation
- ✅ Basic testing suite
- ✅ Documentation

### Phase 2 (Q2 2024)
- 🔄 Web interface development
- 🔄 Mobile app for farmers
- 🔄 Integration with weather APIs

### Phase 3 (Q3 2024)
- 📋 Advanced analytics dashboard
- 📋 Multi-chain support
- 📋 AI-powered risk assessment

### Phase 4 (Q4 2024)
- 📋 Satellite imagery integration
- 📋 IoT sensor network
- 📋 Global expansion

## Acknowledgments

- Stacks Foundation for blockchain infrastructure
- Agricultural insurance industry experts
- Open source community contributors
- Beta testing farmers and insurance providers
