export default (compareValue, asIs = false) => function largerOrEqualThan(value, parentVm) {
    if (asIs) {
        return value >= compareValue;
    }

    // if both values are set, the given value must be larger than the compare value
    return !parentVm[compareValue] || !value || value >= parentVm[compareValue];
};