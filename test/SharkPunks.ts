import hre from 'hardhat';
import { expect } from 'chai';
import { time } from '@nomicfoundation/hardhat-network-helpers';

describe('SharkPunks', function () {
    it('Should mint safe', async function () {
        // get contract
        const SharkPunks = await hre.ethers.getContractFactory('SharkPunks');
        const sharkPunks = await SharkPunks.deploy();

        // mint safe
        expect(await sharkPunks.mintSafe(1)).to.equal(true);
    });
});