import moment from 'moment';

const ssMonth = 4;
const wsMonth = 10;

export const WS = 0;
export const SS = 1;

/**
 * A human-readable string for the current year(s) of the semester
 * @param semester
 * @param year
 * @returns {string}
 */
function getYearString(semester, year) {
    return year.toString().substring(2)
        + (semester === WS ? '/' + (year + 1).toString().substring(2) : '');
}

/**
 * A human-readable string for the current semester
 * @param semester
 * @returns {string}
 */
function getSemesterString(semester) {
    return semester === WS ? 'WS' : 'SS';
}

/**
 * A human-readable string for the current semester + year(s)
 * @param semester
 * @param year
 * @returns {string}
 */
function getFullString(semester, year) {
    return getSemesterString(semester) + ' ' + getYearString(semester, year);
}

/**
 * An object with the calculated semester data from a given moment
 * @param date
 * @returns {{semester: number, semesterString: string, year: number, yearString: string, value: string}}
 */
function calculateSemester(date) {
    const year = date.year();
    const month = date.month() + 1; // 0-indexed

    const semester = month >= ssMonth && month < wsMonth ? SS : WS;

    return {
        semester,
        semesterString: getSemesterString(semester),
        year,
        yearString: getYearString(semester, year),
        value: getFullString(semester, year),
    };
}

/**
 * Calculate the current semester
 * @returns {{semester: number, semesterString: string, year: number, yearString: string, value: string}}
 */
export function current() {
    return calculateSemester(moment());
}

/**
 * Calculate the next semester
 * @returns {{semester: number, semesterString: string, year: number, yearString: string, value: string}}
 */
export function next() {
    return calculateSemester(moment().add(6, 'months'));
}

export default {WS, SS, current, next};