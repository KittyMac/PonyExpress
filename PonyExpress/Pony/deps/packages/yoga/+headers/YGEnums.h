/*
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

enum YGAlign {
  YGAlignAuto,
  YGAlignFlexStart,
  YGAlignCenter,
  YGAlignFlexEnd,
  YGAlignStretch,
  YGAlignBaseline,
  YGAlignSpaceBetween,
  YGAlignSpaceAround
};

enum YGDimension {
  YGDimensionWidth, 
  YGDimensionHeight
};

enum YGDirection {
  YGDirectionInherit,
  YGDirectionLTR,
  YGDirectionRTL
};

enum YGDisplay {
  YGDisplayFlex, 
  YGDisplayNone
};

enum YGEdge {
  YGEdgeLeft,
  YGEdgeTop,
  YGEdgeRight,
  YGEdgeBottom,
  YGEdgeStart,
  YGEdgeEnd,
  YGEdgeHorizontal,
  YGEdgeVertical,
  YGEdgeAll
};

enum YGFlexDirection {
  YGFlexDirectionColumn,
  YGFlexDirectionColumnReverse,
  YGFlexDirectionRow,
  YGFlexDirectionRowReverse
};

enum YGJustify {
  YGJustifyFlexStart,
  YGJustifyCenter,
  YGJustifyFlexEnd,
  YGJustifySpaceBetween,
  YGJustifySpaceAround,
  YGJustifySpaceEvenly
};

enum YGLogLevel {
  YGLogLevelError,
  YGLogLevelWarn,
  YGLogLevelInfo,
  YGLogLevelDebug,
  YGLogLevelVerbose,
  YGLogLevelFatal
};

enum YGMeasureMode {
  YGMeasureModeUndefined,
  YGMeasureModeExactly,
  YGMeasureModeAtMost
};

enum YGNodeType {
  YGNodeTypeDefault, 
  YGNodeTypeText
};

enum YGOverflow {
  YGOverflowVisible,
  YGOverflowHidden,
  YGOverflowScroll
};

enum YGPositionType {
  YGPositionTypeRelative, 
  YGPositionTypeAbsolute
};

enum YGPrintOptions {
  YGPrintOptionsLayout = 1,
  YGPrintOptionsStyle = 2,
  YGPrintOptionsChildren = 4
};

enum YGUnit {
  YGUnitUndefined,
  YGUnitPoint,
  YGUnitPercent,
  YGUnitAuto
};

enum YGWrap {
  YGWrapNoWrap, 
  YGWrapWrap, 
  YGWrapWrapReverse
};
