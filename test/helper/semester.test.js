import * as semester from '@/helper/semester';

// 2222-2-22 22:22:22
Date.now = jest.fn(() => 7956915742000);

describe('semester.test.js', () => {
    it('has WS and SS constants matching rails API', () => {
        expect(semester.WS).toBe('W');
        expect(semester.SS).toBe('S');
    });

    it('calculates correct current semester', () => {
        const current = semester.current();

        expect(current.semesterStart.format('YYYY-MM-DD')).toBe('2221-10-01');
        expect(current.semester).toBe(semester.WS);
        expect(current.year).toBe(2221);
        expect(current.fullString).toBe('WS 21/22');
        expect(current.valueString).toBe('W*2221');
    });

    it('calculates correct next semester', () => {
        const next = semester.next();

        expect(next.semesterStart.format('YYYY-MM-DD')).toBe('2222-04-01');
        expect(next.semester).toBe(semester.SS);
        expect(next.year).toBe(2222);
        expect(next.fullString).toBe('SS 22');
        expect(next.valueString).toBe('S*2222');
    });

    it('calculates correct semester info', () => {
        const infoSS = semester.info(semester.SS, 2222);

        expect(infoSS.semesterStart.format('YYYY-MM-DD')).toBe('2222-04-01');
        expect(infoSS.semester).toBe(semester.SS);
        expect(infoSS.year).toBe(2222);
        expect(infoSS.fullString).toBe('SS 22');
        expect(infoSS.valueString).toBe('S*2222');

        const infoWS = semester.info(semester.WS, 2221);

        expect(infoWS.semesterStart.format('YYYY-MM-DD')).toBe('2221-10-01');
        expect(infoWS.semester).toBe(semester.WS);
        expect(infoWS.year).toBe(2221);
        expect(infoWS.fullString).toBe('WS 21/22');
        expect(infoWS.valueString).toBe('W*2221');
    });
});