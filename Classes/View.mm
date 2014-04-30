//
//  View.mm
//
//  Created by David Whetstone on 2013.07.14.
//  Copyright 2013 David Whetstone. All rights reserved.
//

#import <algorithm>
#import "View.h"
#import "NSObject+AutoLayoutDSL.h"
#import "NSLayoutConstraint+AutoLayoutDSL.h"

namespace AutoLayoutDSL
{

View::View() : _attribute(NSLayoutAttributeNotAnAttribute), _view(nil), _scale(1.0), _offset(0.0)
{
}

View::View(View const &rhs) : _view(rhs._view), _attribute(rhs._attribute), _scale(rhs._scale), _offset(rhs._offset)
{
}

View::View(UIView *view) : _attribute(NSLayoutAttributeNotAnAttribute), _view(view), _scale(1.0), _offset(0.0)
{
    view.translatesAutoresizingMaskIntoConstraints = NO;
}

View::View(View const &viewHolder, UIView *view)
    : _attribute(viewHolder._attribute), _view(view), _scale(viewHolder._scale), _offset(viewHolder._offset)
{
}

View &View::operator = (View rhs)
{
    rhs.swap(*this);
    return *this;
}

void View::swap(View &view) throw()
{
    std::swap(_view, view._view);
    std::swap(_attribute, view._attribute);
    std::swap(_scale, view._scale);
    std::swap(_offset, view._offset);
}

ConstraintBuilder View::operator == (const View &rhs)
{
    return ConstraintBuilder(*this, NSLayoutRelationEqual, rhs);
}

ConstraintBuilder View::operator == (CGFloat rhs)
{
    return ConstraintBuilder(*this, NSLayoutRelationEqual, View() + rhs);
}

ConstraintBuilder View::operator <= (const View &rhs)
{
    return ConstraintBuilder(*this, NSLayoutRelationLessThanOrEqual, rhs);
}

ConstraintBuilder View::operator <= (CGFloat rhs)
{
    return ConstraintBuilder(*this, NSLayoutRelationLessThanOrEqual, View() + rhs);
}

ConstraintBuilder View::operator >= (const View &rhs)
{
    return ConstraintBuilder(*this, NSLayoutRelationGreaterThanOrEqual, rhs);
}

ConstraintBuilder View::operator >= (CGFloat rhs)
{
    return ConstraintBuilder(*this, NSLayoutRelationGreaterThanOrEqual, View() + rhs);
}

View & View::operator *(CGFloat value)
{
    _scale *= value;
    return *this;
}

View & operator *(CGFloat value, View &rhs)
{
    return rhs.operator*(value);
}

View & View::operator /(CGFloat value)
{
    return operator*(1.0f/value);
}

View & View::operator +(CGFloat value)
{
    _offset += value;
    return *this;
}

View & operator +(CGFloat value, View &rhs)
{
    return rhs.operator+(value);
}

View & View::operator -(CGFloat value)
{
    return operator+(-value);
}

View & operator -(CGFloat value, View &rhs)
{
    return rhs.operator-(value);
}

View & View::left()
{
    _attribute = NSLayoutAttributeLeft;
    return *this;
}

View & View::minX()
{
    return left();
}

View & View::midX()
{
    _attribute = NSLayoutAttributeCenterX;
    return *this;
}

View & View::centerX()
{
    _attribute = NSLayoutAttributeCenterX;
    return *this;
}

View & View::right()
{
    _attribute = NSLayoutAttributeRight;
    return *this;
}

View & View::maxX()
{
    return right();
}

View & View::width()
{
    _attribute = NSLayoutAttributeWidth;
    return *this;
}

View & View::leading()
{
    _attribute = NSLayoutAttributeLeading;
    return *this;
}

View & View::trailing()
{
    _attribute = NSLayoutAttributeTrailing;
    return *this;
}

View & View::top()
{
    _attribute = NSLayoutAttributeTop;
    return *this;
}

View & View::minY()
{
    return top();
}

View & View::midY()
{
    _attribute = NSLayoutAttributeCenterY;
    return *this;
}

View & View::centerY()
{
    _attribute = NSLayoutAttributeCenterY;
    return *this;
}

View & View::bottom()
{
    _attribute = NSLayoutAttributeBottom;
    return *this;
}

View & View::maxY()
{
    return bottom();
}

View & View::height()
{
    _attribute = NSLayoutAttributeHeight;
    return *this;
}

View& View::baseline()
{
    _attribute = NSLayoutAttributeBaseline;
    return *this;
}

NSString *View::str() const
{
    if (_attribute != NSLayoutAttributeNotAnAttribute)
        return [NSString stringWithFormat:@"%@%@%@%@", scaleStr(), viewStr(), attributeStr(), offsetStr()];

    return [NSString stringWithFormat:@"%.1f", _offset];
}

NSString *View::viewStr() const
{
    return _view.layoutID;
}

NSString *View::attributeStr() const
{
    return [NSString stringWithFormat:@".%@", NSStringFromNSLayoutAttribute(_attribute)];
}

NSString *View::offsetStr() const
{
    if (_offset < 0.0)
        return [NSString stringWithFormat:@" - %.1f", fabs(_offset)];
    if (_offset > 0.0)
        return [NSString stringWithFormat:@" + %.1f", _offset];
    return @"";
}

NSString *View::scaleStr() const
{
    return _scale > 1.0 ? [NSString stringWithFormat:@"%.1f*", _scale] : @"";
}

} // namespace AutoLayoutDSL

