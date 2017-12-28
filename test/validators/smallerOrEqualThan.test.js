import smallerOrEqualThan from '@/validators/smallerOrEqualThan';

describe('smallerOrEqualThan.test.js', () => {
    it('compares values with the parentVm', () => {
        const validator = smallerOrEqualThan('key');
        expect(validator('2017-11-05', { key: '2017-11-03' })).toBe(false);
        expect(validator('2017-11-05', { key: '2017-11-05' })).toBe(true);
        expect(validator('2017-11-05', { key: '2017-11-07' })).toBe(true);
    });
});