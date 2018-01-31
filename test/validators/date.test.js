import date from '@/validators/date';

describe('The date validator', () => {
    it('returns correct validity info on various dates', () => {
        const validator = date();
        expect(validator('2017-11-05')).toBe(true);
    
        expect(validator('1999-11-05')).toBe(true);
        expect(validator('something that is definitely not a date')).toBe(false);
    });
});
