import { slugify } from '@/helper/util';

describe('util.test.js', () => {
    it('slugifies a string', () => {
        expect(slugify('A String With A Lot Of Spaces')).toBe('a-string-with-a-lot-of-spaces');
    });
});
