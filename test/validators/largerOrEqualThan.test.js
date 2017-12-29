import largerOrEqualThan from '@/validators/largerOrEqualThan';

describe('largerOrEqualThan.test.js', () => {
    it('compares values with the parentVm', () => {
        const validator = largerOrEqualThan('key');
        expect(validator('2017-11-05', { key: '2017-11-03' })).toBe(true);
        expect(validator('2017-11-05', { key: '2017-11-05' })).toBe(true);
        expect(validator('2017-11-05', { key: '2017-11-07' })).toBe(false);
    });

    it('compares values as is', () => {
        const validator = largerOrEqualThan('2017-11-05', true);
        expect(validator('2017-11-03')).toBe(false);
        expect(validator('2017-11-05')).toBe(true);
        expect(validator('2017-11-07')).toBe(true);
    });
});
