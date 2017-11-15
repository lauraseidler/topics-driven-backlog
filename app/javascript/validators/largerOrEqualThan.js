export default compareValue => function largerOrEqualThan(value, parentVm) {
    // if both values are set, the given value must be larger than the compare value
    return !parentVm[compareValue] || !value || value >= parentVm[compareValue];
};